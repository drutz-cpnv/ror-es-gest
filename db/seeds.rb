require 'faker'

ActiveRecord::Base.transaction do
  # --- Common Data ---
  address = Address.create!(zip: 1406, town: "Cronay", street: "Route de la Menthue", number: "11")

  active_status = Status.create!(title: "Active", slug: "active")

  sector = Sector.create!(name: "Informatique")

  primary_teacher = Teacher.create!(
    username: "ngy",
    lastname: "GLASSEY",
    firstname: "Nicolas",
    email: "ngy@eduvaud.ch",
    phone_number: "1234567890",
    password: "password",
    password_confirmation: "password",
    address: address,
    status_id: active_status.id,
    iban: "IBAN123456"
  )

  other_teacher = Teacher.create!(
    username: "are",
    lastname: "DE-LAMEGO-RESENDE",
    firstname: "Ana",
    email: "are@eduvaud.ch",
    phone_number: "1234567890",
    password: "password",
    password_confirmation: "password",
    address: address,
    status_id: active_status.id,
    iban: "IBAN123456"
  )

  cki = Teacher.create!(
    username: "cki",
    lastname: "KOHLI",
    firstname: "Charles-Henri",
    email: "cki@eduvaud.ch",
    phone_number: "1234567890",
    password: "password",
    password_confirmation: "password",
    address: address,
    status_id: active_status.id,
    iban: "IBAN123456"
  )

  # Création de plusieurs enseignants avec Faker
  teachers = []
  20.times do |i|
    firstname = Faker::Name.first_name
    lastname = Faker::Name.last_name.upcase
    username = "#{firstname[0..1]}#{lastname[0..1]}".downcase

    teacher = Teacher.create!(
      username: username,
      lastname: lastname,
      firstname: firstname,
      email: "#{username}@eduvaud.ch",
      phone_number: Faker::PhoneNumber.phone_number,
      password: "password",
      password_confirmation: "password",
      address: address,
      status_id: active_status.id,
      iban: Faker::Bank.iban(country_code: 'CH')
    )

    teachers << teacher
  end

  dean = Dean.create!(
    username: "cha",
    lastname: "HARDEGGER",
    firstname: "Cindy",
    email: "cha@eduvaud.ch",
    phone_number: "1112223333",
    password: "password",
    password_confirmation: "password",
    address_id: address.id,
    status_id: active_status.id,
    iban: "IBANDEAN"
  )

  math = Subject.create!(slug: "math", name: "Mathematics")
  history = Subject.create!(slug: "history", name: "History")
  # Ajout de nouvelles matières
  french = Subject.create!(slug: "french", name: "French")
  science = Subject.create!(slug: "science", name: "Science")
  art = Subject.create!(slug: "art", name: "Art")
  sports = Subject.create!(slug: "sports", name: "Sports")

  # --- Create Moments ---
  # For each academic year, create a Year moment, two Semester moments, and four Quarter moments.
  # We assume the following mapping for moment_type:
  # 0 = YEAR, 1 = SEMESTER, 2 = QUARTER
  academic_years = (2022..2025).to_a
  year_moments = []
  semester_moments = []
  quarter_moments = []

  academic_years.each do |year|
    # Year moment: from Aug 21 of current year to June 30 of next year.
    year_moment = Moment.create!(
      uid: "Y#{year}",
      start_on: Date.new(year, 8, 21),
      end_on: Date.new(year + 1, 6, 30),
      moment_type: 0 # YEAR
    )
    year_moments << year_moment

    PromotionAssert.create!(
      description: "Promotion si aucune note inférieur à 4",
      function: "def is_promoted(grades)
  return !grades.any? { |_, note| note < 4 }
end",
      moment: year_moment,
      sector: sector
    )

    # Semester moments:
    # Semester 1: Aug 21 to Jan 20
    s1 = Moment.create!(
      uid: "Y#{year}S1",
      start_on: Date.new(year, 8, 21),
      end_on: Date.new(year + 1, 1, 20),
      moment_type: 1 # SEMESTER
    )
    # Semester 2: Jan 21 to June 30
    s2 = Moment.create!(
      uid: "Y#{year}S2",
      start_on: Date.new(year + 1, 1, 21),
      end_on: Date.new(year + 1, 6, 30),
      moment_type: 1 # SEMESTER
    )
    semester_moments.concat([s1, s2])

    # Quarter moments:
    # For Semester 1, split into two quarters:
    q1 = Moment.create!(
      uid: "Y#{year}S1T1",
      start_on: Date.new(year, 8, 21),
      end_on: Date.new(year, 11, 3),
      moment_type: 2 # QUARTER
    )
    q2 = Moment.create!(
      uid: "Y#{year}S1T2",
      start_on: Date.new(year, 11, 4),
      end_on: Date.new(year + 1, 1, 20),
      moment_type: 2 # QUARTER
    )
    # For Semester 2:
    q3 = Moment.create!(
      uid: "Y#{year}S2T1",
      start_on: Date.new(year + 1, 1, 21),
      end_on: Date.new(year + 1, 4, 14),
      moment_type: 2 # QUARTER
    )
    q4 = Moment.create!(
      uid: "Y#{year}S2T2",
      start_on: Date.new(year + 1, 4, 15),
      end_on: Date.new(year + 1, 6, 30),
      moment_type: 2 # QUARTER
    )
    quarter_moments.concat([q1, q2, q3, q4])
  end

  # --- Create Classes ---
  # Classes are associated with the Year moment.
  # For each year moment, create four classes named: SI-T1a, SI-T1b, SI-T2a, SI-T2b.
  class_names = ["SI-T1a", "SI-T1b", "SI-T2a", "SI-T2b"]
  school_classes = []

  year_moments.each do |year_moment|
    class_names.each do |name|
      room = Room.create!(name: "Room #{name}")

      school_classes << SchoolClass.create!(
        uid: "#{year_moment.uid}_#{name}",
        name: name,
        moment_id: year_moment.id,
        room_id: room.id,
        teacher: primary_teacher,
        sector_id: sector.id
      )
    end
  end

  # --- Create 10 Students per Class ---
  school_classes.each do |s_class|
    10.times do |i|
      firstname = Faker::Name.first_name
      lastname = Faker::Name.last_name
      username = "#{firstname}_#{lastname}".downcase

      student = Student.create!(
        username: username,
        lastname: lastname,
        firstname: firstname,
        email: "#{username}@eduvaud.ch",
        phone_number: Faker::PhoneNumber.phone_number,
        password: "password",
        password_confirmation: "password",
        address_id: address.id,
        status_id: active_status.id,
        iban: Faker::Bank.iban(country_code: 'CH')
      )
      student.school_classes = [s_class]
    end
  end

  # --- Create Courses for Each Class ---
  # Pour chaque classe, attribuer des cours sur plusieurs jours de la semaine
  school_classes.each do |s_class|
    # Cours du lundi
    Course.create!(
      start_at: Time.parse("09:00"),
      end_at: Time.parse("10:30"),
      week_day: 1, # Monday
      teacher: other_teacher,
      school_class: s_class,
      subject: math,
      moment: s_class.moment
    )
    Course.create!(
      start_at: Time.parse("10:45"),
      end_at: Time.parse("12:15"),
      week_day: 1, # Monday
      teacher: cki,
      school_class: s_class,
      subject: history,
      moment: s_class.moment
    )

    # Cours du mardi
    Course.create!(
      start_at: Time.parse("08:30"),
      end_at: Time.parse("10:00"),
      week_day: 2, # Tuesday
      teacher: teachers.sample,
      school_class: s_class,
      subject: french,
      moment: s_class.moment
    )

    # Cours du mercredi
    Course.create!(
      start_at: Time.parse("13:30"),
      end_at: Time.parse("15:00"),
      week_day: 3, # Wednesday
      teacher: teachers.sample,
      school_class: s_class,
      subject: science,
      moment: s_class.moment
    )

    # Cours du jeudi
    Course.create!(
      start_at: Time.parse("10:15"),
      end_at: Time.parse("11:45"),
      week_day: 4, # Thursday
      teacher: teachers.sample,
      school_class: s_class,
      subject: art,
      moment: s_class.moment
    )

    # Cours du vendredi
    Course.create!(
      start_at: Time.parse("14:00"),
      end_at: Time.parse("15:30"),
      week_day: 5, # Friday
      teacher: teachers.sample,
      school_class: s_class,
      subject: sports,
      moment: s_class.moment
    )
  end

  # --- Create Examinations and Grades ---
  # Récupérer tous les cours créés
  all_courses = Course.all
  all_students = Student.all

  # Pour chaque cours, créer plusieurs examens
  exam_titles = [
    "Contrôle des connaissances",
    "Examen intermédiaire",
    "Examen final",
    "Test pratique",
    "Évaluation continue",
    "Quiz"
  ]

  all_courses.each do |course|
    # Créer 2 à 4 examens pour chaque cours
    num_exams = rand(2..4)

    num_exams.times do |i|
      # Date d'examen entre le début et la fin du moment
      date_range = (course.moment.start_on + 2.weeks)..(course.moment.end_on - 2.weeks)
      exam_date = Faker::Date.between(from: date_range.begin, to: date_range.end)

      # Créer l'examen
      examination = Examination.create!(
        title: "#{exam_titles.sample} - #{course.subject.name}",
        effective_date: exam_date,
        course_id: course.id
      )

      # Récupérer tous les élèves de cette classe
      class_students = course.school_class.students

      # Pour chaque élève de la classe, créer une note (1.0 à 6.0)
      class_students.each do |student|
        # Générer une note entre 1.0 et 6.0 (précision de 0.5)
        # Note moyenne en Suisse: entre 4.0 et 5.0 pour les bons élèves
        if rand < 0.7 # 70% de chance d'avoir une bonne note
          value = [4.0, 4.5, 5.0, 5.5, 6.0].sample
        else
          value = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5].sample
        end

        # Créer la note pour cet élève
        Grade.create!(
          value: value,
          execute_on: exam_date, # Date d'exécution identique à la date de l'examen
          examination_id: examination.id,
          student_id: student.id
        )
      end
    end
  end

  puts "Seed data created successfully: Year, Semester, Quarter moments; classes; courses; students; extra teachers; dean; examinations and grades."
end
