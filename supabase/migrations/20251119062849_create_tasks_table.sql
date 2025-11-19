/*
  # Task Management System Schema

  ## Overview
  This migration creates the core database structure for a task management application
  with user authentication support.

  ## New Tables
  
  ### `tasks`
  User tasks with CRUD capabilities
  - `id` (uuid, primary key) - Unique task identifier
  - `user_id` (uuid, foreign key) - Links to auth.users
  - `title` (text, required) - Task title
  - `description` (text) - Optional detailed description
  - `status` (text) - Task status: 'pending', 'in_progress', 'completed'
  - `priority` (text) - Priority level: 'low', 'medium', 'high'
  - `due_date` (timestamptz) - Optional due date
  - `created_at` (timestamptz) - Timestamp of creation
  - `updated_at` (timestamptz) - Timestamp of last update

  ## Security
  
  ### Row Level Security (RLS)
  - Enabled on all tables
  - Users can only access their own tasks
  
  ### Policies
  1. **Select Policy**: Users can view only their own tasks
  2. **Insert Policy**: Users can create tasks for themselves
  3. **Update Policy**: Users can update only their own tasks
  4. **Delete Policy**: Users can delete only their own tasks

  ## Indexes
  - Index on user_id for efficient task queries
  - Index on status for filtering
  - Index on created_at for sorting
*/

CREATE TABLE IF NOT EXISTS tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  description text DEFAULT '',
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed')),
  priority text DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
  due_date timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own tasks"
  ON tasks
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own tasks"
  ON tasks
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own tasks"
  ON tasks
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own tasks"
  ON tasks
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_tasks_user_id ON tasks(user_id);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_created_at ON tasks(created_at DESC);