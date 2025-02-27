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
    address: address,
    status_id: active_status.id,
    iban: "IBAN123456"
  )

  cki = Teacher.create!(
    username: "cki",
    lastname: "KOHLI",
    firstname: "Charles-Henri",
    email: "are@eduvaud.ch",
    phone_number: "1234567890",
    address: address,
    status_id: active_status.id,
    iban: "IBAN123456"
  )

  dean = Dean.create!(
    username: "cha",
    lastname: "HARDEGGER",
    firstname: "Cindy",
    email: "cha@eduvaud.ch",
    phone_number: "1112223333",
    address_id: address.id,
    status_id: active_status.id,
    iban: "IBANDEAN"
  )

  math    = Subject.create!(slug: "math", name: "Mathematics")
  history = Subject.create!(slug: "history", name: "History")

  # --- Create Moments ---
  # For each academic year, create a Year moment, two Semester moments, and four Quarter moments.
  # We assume the following mapping for moment_type:
  # 0 = YEAR, 1 = SEMESTER, 2 = QUARTER
  academic_years = (2022..2025).to_a
  year_moments     = []
  semester_moments = []
  quarter_moments  = []

  academic_years.each do |year|
    # Year moment: from Aug 21 of current year to June 30 of next year.
    year_moment = Moment.create!(
      uid: "Y#{year}",
      start_on: Date.new(year, 8, 21),
      end_on: Date.new(year + 1, 6, 30),
      moment_type: 0  # YEAR
    )
    year_moments << year_moment

    # Semester moments:
    # Semester 1: Aug 21 to Jan 20
    s1 = Moment.create!(
      uid: "Y#{year}S1",
      start_on: Date.new(year, 8, 21),
      end_on: Date.new(year + 1, 1, 20),
      moment_type: 1  # SEMESTER
    )
    # Semester 2: Jan 21 to June 30
    s2 = Moment.create!(
      uid: "Y#{year}S2",
      start_on: Date.new(year + 1, 1, 21),
      end_on: Date.new(year + 1, 6, 30),
      moment_type: 1  # SEMESTER
    )
    semester_moments.concat([s1, s2])

    # Quarter moments:
    # For Semester 1, split into two quarters:
    q1 = Moment.create!(
      uid: "Y#{year}S1T1",
      start_on: Date.new(year, 8, 21),
      end_on: Date.new(year, 11, 3),
      moment_type: 2  # QUARTER
    )
    q2 = Moment.create!(
      uid: "Y#{year}S1T2",
      start_on: Date.new(year, 11, 4),
      end_on: Date.new(year + 1, 1, 20),
      moment_type: 2  # QUARTER
    )
    # For Semester 2:
    q3 = Moment.create!(
      uid: "Y#{year}S2T1",
      start_on: Date.new(year + 1, 1, 21),
      end_on: Date.new(year + 1, 4, 14),
      moment_type: 2  # QUARTER
    )
    q4 = Moment.create!(
      uid: "Y#{year}S2T2",
      start_on: Date.new(year + 1, 4, 15),
      end_on: Date.new(year + 1, 6, 30),
      moment_type: 2  # QUARTER
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
      student = Student.create!(
        username: "student_#{s_class.uid}_#{i+1}",
        lastname: "Student#{i+1}",
        firstname: "Student#{i+1}",
        email: "student_#{s_class.uid}_#{i+1}@eduvaud.ch",
        phone_number: "0000000000",
        address_id: address.id,
        status_id: active_status.id,
        iban: "IBANSTUDENT#{i+1}"
      )
      student.school_classes = [s_class]
    end
  end

  # --- Create Courses for Each Class ---
  # For simplicity, assign two courses (Mathematics and History) to each class on Monday.
  school_classes.each do |s_class|
    Course.create!(
      start_at: Time.parse("09:00"),
      end_at: Time.parse("10:30"),
      week_day: 1,  # Monday
      teacher: other_teacher,
      school_class: s_class,
      subject: math,
      moment: s_class.moment
    )
    Course.create!(
      start_at: Time.parse("10:45"),
      end_at: Time.parse("12:15"),
      week_day: 1,  # Monday
      teacher: cki,
      school_class: s_class,
      subject: history,
      moment: s_class.moment
    )
  end

  puts "Seed data created successfully: Year, Semester, Quarter moments; classes; courses; students; extra teachers; and dean."
end
