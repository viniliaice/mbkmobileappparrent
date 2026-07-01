-- 1. Speed up inbox-loading queries (filter by recipientId, ordered by createdAt)
CREATE INDEX IF NOT EXISTS idx_messages_recipient_id_created_at
  ON public.messages ("recipientId", "createdAt" DESC);

-- 2. Speed up sent-messages queries (filter by senderId, ordered by createdAt)
CREATE INDEX IF NOT EXISTS idx_messages_sender_id_created_at
  ON public.messages ("senderId", "createdAt" DESC);

-- 3. Speed up N+1 prevention bulk-resolve on sender names
CREATE INDEX IF NOT EXISTS idx_users_id
  ON public.users ("id");

-- 4. Speed up exam-loading queries per student
CREATE INDEX IF NOT EXISTS idx_exams_student_id_date
  ON public.exams ("studentId", "date" DESC);

-- 5. Speed up attendance queries by student id
CREATE INDEX IF NOT EXISTS idx_attendance_student_id_date
  ON public.attendance ("studentId", "date" DESC);

-- 6. Speed up homework queries by student id
CREATE INDEX IF NOT EXISTS idx_homework_student_id_due_date
  ON public.homework ("studentId", "dueDate" DESC);

-- 7. Speed up announcements filtered by class name
CREATE INDEX IF NOT EXISTS idx_announcements_class_name_created_at
  ON public.announcements ("className", "createdAt" DESC);

-- 8. Speed up report_comments lookups per student
CREATE INDEX IF NOT EXISTS idx_report_comments_student_id
  ON public.report_comments ("studentId");
