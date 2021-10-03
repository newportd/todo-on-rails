require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:testuser)
    @task = tasks(:testtask)
  end

  test "manage tasks" do
    # login
    sign_in @user
    visit root_path
    assert_current_path root_path

    # validate the task list
    assert_table 'task-list', :rows => [
      ["This is my task.", "", "Show", "Edit", "Delete"]
    ]

    # add a new task
    click_link 'New Task'
    assert_current_path new_task_path

    fill_in 'Body', with: "Here is a second task."
    click_button 'Create Task'
    navigate_home

    # validate the task list contains the new task
    assert_table 'task-list', :rows => [
      ["This is my task.", "", "Show", "Edit", "Delete"],
      ["Here is a second task.", "", "Show", "Edit", "Delete"]
    ]

    click_task_link @task.body, 'Show'
    assert_current_path task_path(@task)
    within :xpath, "//p[strong[text()='Body:']]" do
      assert_text @task.body
    end
    navigate_home

    click_task_link 'Here is a second task.', 'Edit'
    fill_in 'Body', with: 'Here is a modified second task.'
    click_button 'Update Task'
    navigate_home

    # validate the task list contains the updated task
    assert_table 'task-list', :rows => [
      ["This is my task.", "", "Show", "Edit", "Delete"],
      ["Here is a modified second task.", "", "Show", "Edit", "Delete"]
    ]

    # delete the new task
    accept_confirm 'Are you sure you want to delete this task?' do
      click_task_link 'Here is a modified second task.', 'Delete'
    end

    assert_table 'task-list', :rows => [
      ["This is my task.", "", "Show", "Edit", "Delete"]
    ]
  end

  private
    
  def click_task_link(task_body, link_text)
    within_table 'task-list' do
      find(:xpath, "./tbody/tr[td[text()='#{task_body}']]/td/a", text: link_text).click
    end
  end

  def navigate_home
    click_link 'Home'
    assert_current_path root_path
  end
end
