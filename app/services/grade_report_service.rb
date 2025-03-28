require "prawn"
require "prawn/table"

class GradeReportService
  def initialize(student, moment)
    @student = student
    @moment = moment
    @grades = {}
    @promotion_assert = PromotionAssert.find_by(moment: @moment, sector: @moment.school_classes.first.sector)
  end

  def generate_pdf
    Prawn::Document.new(page_size: "A4", margin: 36) do |pdf|
      # Nouvelle palette de couleurs (tons de gris et accent)
      dark_gray = "2D3748"
      mid_gray = "718096"
      light_gray = "E2E8F0"
      accent = "FF6B6B"
      success = "68D391"
      white = "FFFFFF"

      # Logo/En-tête stylisé
      pdf.fill_color dark_gray
      pdf.font("Helvetica", style: :bold) do
        pdf.text "BULLETIN SCOLAIRE", size: 28, align: :right
      end

      # Informations dans un cadre propre
      pdf.stroke_color light_gray
      pdf.line_width 1
      pdf.stroke_rounded_rectangle [0, pdf.cursor], pdf.bounds.width, 100, 3

      # Contenu du cadre des infos
      pdf.bounding_box([10, pdf.cursor - 10], width: pdf.bounds.width - 20, height: 100) do
        pdf.fill_color dark_gray

        # Colonne gauche
        pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width / 2, height: 60) do
          pdf.font("Helvetica", style: :bold) do
            pdf.text "ÉTUDIANT", size: 10
          end
          pdf.move_down 5
          pdf.font("Helvetica") do
            pdf.text @student.fullname, size: 14
          end
        end

        # Colonne droite
        pdf.bounding_box([pdf.bounds.width / 2, pdf.cursor + 60], width: pdf.bounds.width / 2, height: 100) do
          pdf.font("Helvetica", style: :bold) do
            pdf.text "PÉRIODE", size: 10
          end
          pdf.move_down 5
          pdf.font("Helvetica") do
            pdf.text @moment.display_name, size: 14
          end
          pdf.move_down 8
          pdf.font("Helvetica", style: :bold) do
            pdf.text "DATE", size: 10
          end
          pdf.move_down 5
          pdf.font("Helvetica") do
            pdf.text Date.today.strftime('%d/%m/%Y'), size: 14
          end
        end
      end
      pdf.move_down 10

      # Titre section notes
      pdf.fill_color dark_gray
      pdf.font("Helvetica", style: :bold) do
        pdf.text "RÉSULTATS", size: 16, character_spacing: 1
        pdf.fill_color mid_gray
        pdf.text "Année académique", size: 10
      end
      pdf.move_down 15

      # Calcul des données du tableau
      table_data = grades_table_data

      # Calcul des largeurs de colonnes
      total_columns = table_data.first.size

      # Calculer la largeur des colonnes
      column_widths = []
      column_widths[0] = 140 # Matière
      remaining_width = pdf.bounds.width - column_widths[0]
      col_width = remaining_width / (total_columns - 1)

      # Remplir le tableau de largeurs
      (1...total_columns).each do |i|
        column_widths[i] = col_width
      end

      # Style du tableau - Minimaliste
      pdf.font("Helvetica", size: 10) do
        pdf.table(table_data, width: pdf.bounds.width, column_widths: column_widths) do |t|
          # Style de base - Tableau très épuré
          t.cells.border_width = 0
          t.cells.padding = [10, 5]

          # En-tête plus subtil
          t.row(0).font_style = :bold
          t.row(0).borders = [:bottom]
          t.row(0).border_width = 1.5
          t.row(0).border_color = accent
          t.row(0).padding = [5, 5, 10, 5] # plus d'espace en bas
          t.row(0).align = :center

          # Colonnes
          t.column(0).align = :left
          t.column(0).font_style = :bold
          t.column(0).text_color = dark_gray

          # Lignes de séparation subtiles
          t.rows(1..-1).borders = [:bottom]
          t.rows(1..-1).border_width = 0.5
          t.rows(1..-1).border_color = light_gray

          # Notes
          (1...(total_columns - 1)).each do |i|
            t.column(i).align = :center
          end

          # Colonne moyenne
          t.column(-1).align = :center
          t.column(-1).font_style = :bold
          t.column(-1).text_color = accent
        end
      end
      pdf.move_down 40

      # Section promotion - Design épuré et minimaliste
      if @promotion_assert
        # Séparateur horizontal
        pdf.stroke_color light_gray
        pdf.line_width 0.5
        pdf.stroke_horizontal_line 0, pdf.bounds.width
        pdf.move_down 20

        # Titre de la section
        pdf.fill_color dark_gray
        pdf.font("Helvetica", style: :bold) do
          pdf.text "DÉCISION", size: 16
        end
        pdf.move_down 15

        # Résultat
        begin
          eval @promotion_assert.function
          result = is_promoted(@grades)


          pdf.text_box "STATUT",
                       at: [0, pdf.cursor],
                       width: 100,
                       height: 30,
                       size: 10,
                       align: :left,
                       style: :bold,
                       character_spacing: 1

          pdf.fill_color = result ? success : accent
          pdf.font("Helvetica", style: :bold) do
            pdf.text_box result ? "PROMU" : "NON PROMU",
                         at: [0, pdf.cursor - 15],
                         width: 150,
                         size: 18
          end

          # Description
          pdf.fill_color mid_gray
          pdf.text_box "Conditions:",
                       at: [200, pdf.cursor],
                       width: pdf.bounds.width - 200,
                       size: 10,
                       style: :bold

          pdf.text_box @promotion_assert.description,
                       at: [200, pdf.cursor - 15],
                       width: pdf.bounds.width - 210,
                       size: 10
        rescue => e
          pdf.fill_color accent
          pdf.text "Erreur: #{e.message}", size: 10
        end
      end

      # Section des signatures
      pdf.move_down 80
      pdf.stroke_color light_gray
      pdf.line_width 0.5
      pdf.stroke_horizontal_line 0, pdf.bounds.width
      pdf.move_down 20

      pdf.fill_color dark_gray
      pdf.font("Helvetica", style: :bold) do
        pdf.text "SIGNATURES", size: 14, character_spacing: 1
      end
      pdf.move_down 10

      # Trois zones de signature
      signature_width = pdf.bounds.width / 3 - 20

      # Première signature - Direction
      pdf.bounding_box([0, pdf.cursor], width: signature_width, height: 80) do
        pdf.font("Helvetica", style: :bold, size: 10) do
          pdf.text "DIRECTION"
        end
        pdf.move_down 50
        pdf.stroke_horizontal_line 0, signature_width - 10
        pdf.move_down 5
        pdf.font("Helvetica", size: 8) do
          pdf.text "Date et signature"
        end
      end

      # Deuxième signature - Professeur principal
      pdf.bounding_box([pdf.bounds.width / 3, pdf.cursor + 80], width: signature_width, height: 80) do
        pdf.font("Helvetica", style: :bold, size: 10) do
          pdf.text "PROFESSEUR PRINCIPAL"
        end
        pdf.move_down 50
        pdf.stroke_horizontal_line 0, signature_width - 10
        pdf.move_down 5
        pdf.font("Helvetica", size: 8) do
          pdf.text "Date et signature"
        end
      end

      # Troisième signature - Parents/Représentant légal
      pdf.bounding_box([pdf.bounds.width * 2 / 3, pdf.cursor + 80], width: signature_width, height: 80) do
        pdf.font("Helvetica", style: :bold, size: 10) do
          pdf.text "PARENTS/REPRÉSENTANT"
        end
        pdf.move_down 50
        pdf.stroke_horizontal_line 0, signature_width - 10
        pdf.move_down 5
        pdf.font("Helvetica", size: 8) do
          pdf.text "Date et signature"
        end
      end

      # Pied de page
      pdf.bounding_box([0, 30], width: pdf.bounds.width, height: 30) do
        pdf.stroke_color light_gray
        pdf.stroke_horizontal_line 0, pdf.bounds.width
        pdf.move_down 10

        pdf.fill_color mid_gray
        pdf.font("Helvetica", size: 8) do
          pdf.text "Document généré le #{Time.now.strftime('%d/%m/%Y à %H:%M')}", align: :center
        end
      end
    end
  end

  private

  def grades_table_data
    # En-tête du tableau
    header = ["Matière"]
    # Déterminer le nombre maximum d'examens pour une matière
    max_exams = 0

    # Collecter toutes les données
    courses_data = []

    @student.school_classes.where(moment: @moment).first.courses.each do |course|
      grades = course.examinations.map do |examination|
        examination.grades.find_by(student: @student)
      end.compact

      if grades.any?
        grade_values = grades.map(&:value)
        max_exams = [max_exams, grade_values.size].max

        courses_data << {
          name: course.subject.name,
          grades: grade_values,
          average: grade_values.empty? ? "N/A" : grade_values.sum.to_f / grade_values.size
        }
      end
    end

    # Compléter l'en-tête avec le nombre approprié de colonnes pour les examens
    max_exams.times do |i|
      header << "Note #{i + 1}"
    end
    header << "Moyenne"

    # Construire le tableau avec l'en-tête et les données
    table_data = [header]

    courses_data.each do |course_data|
      row = [course_data[:name]]

      # Ajouter chaque note dans sa propre cellule
      course_data[:grades].each do |grade|
        row << grade
      end

      # Ajouter des cellules vides si nécessaire pour aligner le tableau
      (max_exams - course_data[:grades].size).times do
        row << ""
      end

      # Ajouter la moyenne
      row << course_data[:average]

      table_data << row
    end

    # Stocker les notes pour l'évaluation de la promotion
    @grades = courses_data.map { |c| [c[:name], c[:average]] }.to_h

    table_data
  end
end 