require "application_system_test_case"

class StudentClassesTest < ApplicationSystemTestCase
  setup do
    @student_class = student_classes(:one)
  end

  test "visiting the index" do
    visit student_classes_url
    assert_selector "h1", text: "Student classes"
  end

  test "should create student class" do
    visit student_classes_url
    click_on "New student class"

    fill_in "School class", with: @student_class.school_class_id
    fill_in "Student", with: @student_class.student_id
    click_on "Create Student class"

    assert_text "Student class was successfully created"
    click_on "Back"
  end

  test "should update Student class" do
    visit student_class_url(@student_class)
    click_on "Edit this student class", match: :first

    fill_in "School class", with: @student_class.school_class_id
    fill_in "Student", with: @student_class.student_id
    click_on "Update Student class"

    assert_text "Student class was successfully updated"
    click_on "Back"
  end

  test "should destroy Student class" do
    visit student_class_url(@student_class)
    click_on "Destroy this student class", match: :first

    assert_text "Student class was successfully destroyed"
  end
end
