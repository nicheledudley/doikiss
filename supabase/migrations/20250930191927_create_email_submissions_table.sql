/*
  # Email Submissions Table

  1. New Tables
    - `email_submissions`
      - `id` (uuid, primary key) - Unique identifier for each submission
      - `email` (text, unique) - Email address submitted by user
      - `created_at` (timestamptz) - Timestamp of submission
      - `ip_address` (text, optional) - IP address for rate limiting (optional)
  
  2. Security
    - Enable RLS on `email_submissions` table
    - Add policy for inserting new email submissions (public access for form)
    - No read/update/delete policies needed for public users
  
  3. Indexes
    - Index on email for quick duplicate checking
    - Index on created_at for sorting

  4. Notes
    - Table allows public inserts but restricts reads to authenticated users only
    - Email field is unique to prevent duplicate submissions
*/

CREATE TABLE IF NOT EXISTS email_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now(),
  ip_address text
);

ALTER TABLE email_submissions ENABLE ROW LEVEL SECURITY;

-- Allow anyone to insert their email (public form submission)
CREATE POLICY "Anyone can submit email"
  ON email_submissions
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Only authenticated users can view submissions (admin access)
CREATE POLICY "Authenticated users can view submissions"
  ON email_submissions
  FOR SELECT
  TO authenticated
  USING (true);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_email_submissions_email ON email_submissions(email);
CREATE INDEX IF NOT EXISTS idx_email_submissions_created_at ON email_submissions(created_at DESC);
