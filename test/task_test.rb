require 'test_helper'

describe StreakClient::Task do

  before do
    @pipeline = StreakClient::Pipeline.create(name: "Test Tasks", description: "T", stageNames: "Test Stage")
    @box = StreakClient::Box.create(@pipeline.pipelineKey, { name: "Test Box" })

    response = @box.add_task('Test Task',nil)
    @task = StreakClient::Task.find response['key']
  end

  after do
    @pipeline.boxes.each { |box| StreakClient::Box.delete(box.boxKey) }
    StreakClient::Pipeline.delete(@pipeline.pipelineKey)
  end

  it 'can delete Tasks' do
    StreakClient::Task.delete(@task.key)
    @box.list_tasks.must_be_empty
  end

  # it 'can remove and assign Users to a Task' do
  #   user = StreakClient::User.find_me
  #
  #   # Remove all users
  #   @task.assign_users([])
  #   @task = StreakClient::Task.find @task.key
  #   @task.assignedToSharingEntries.must_be_empty
  #
  #   # Reassign the main user
  #   @task.assign_users([ { userKey: user.key, email: user.email } ])
  #   @task = StreakClient::Task.find @task.key
  #   @task.assignedToSharingEntries.first['userKey'].must_equal user.key
  # end

  it 'can remove and assign Users to a Task via email only' do
    user = StreakClient::User.find_me

    # Remove all users
    @task.assign_users_by_email([])
    @task = StreakClient::Task.find @task.key
    @task.assignedToSharingEntries.must_be_empty

    # Reassign the main user via email only
    @task.assign_users_by_email([ user.email ])
    @task = StreakClient::Task.find @task.key
    @task.assignedToSharingEntries.first['email'].must_equal user.email
  end


end