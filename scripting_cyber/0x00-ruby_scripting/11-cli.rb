#!/usr/bin/env ruby
require 'optparse'

TASKS_FILE = 'tasks.txt'

def load_tasks
  return [] unless File.exist?(TASKS_FILE)
  File.readlines(TASKS_FILE).map(&:chomp)
end

def save_tasks(tasks)
  File.write(TASKS_FILE, tasks.join("\n") + (tasks.empty? ? "" : "\n"))
end

def add_task(task)
  tasks = load_tasks
  tasks << task
  save_tasks(tasks)
  puts "Task '#{task}' added."
end

def list_tasks
  tasks = load_tasks
  puts "Tasks:"
  tasks.each_with_index do |task, index|
    puts "#{index + 1}. #{task}"
  end
end

def remove_task(index)
  tasks = load_tasks
  task  = tasks.delete_at(index - 1)
  save_tasks(tasks)
  puts "Task '#{task}' removed."
end

options = {}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: cli.rb [options]"

  opts.on("-a", "--add TASK", "Add a new task") do |task|
    options[:action] = :add
    options[:task]   = task
  end

  opts.on("-l", "--list", "List all tasks") do
    options[:action] = :list
  end

  opts.on("-r", "--remove INDEX", "Remove a task by index") do |index|
    options[:action] = :remove
    options[:index]  = index.to_i
  end

  opts.on("-h", "--help", "Show help") do
    puts opts
    exit
  end
end

parser.parse!

case options[:action]
when :add
  add_task(options[:task])
when :list
  list_tasks
when :remove
  remove_task(options[:index])
else
  puts parser
end
