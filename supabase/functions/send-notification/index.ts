import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  try {
    const payload = await req.json()
    const { record } = payload
    if (!record) {
      return new Response('No record', { status: 400 })
    }

    const { id: messageId, senderId, recipientId, subject } = record

    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    )

    const { data: sender } = await supabaseAdmin
      .from('users')
      .select('name')
      .eq('id', senderId)
      .single()

    const { data: recipient } = await supabaseAdmin
      .from('users')
      .select('name, fcm_token')
      .eq('id', recipientId)
      .single()

    if (!recipient?.fcm_token) {
      return new Response('No FCM token', { status: 200 })
    }

    const senderName = sender?.name ?? 'Unknown'
    const fcmServerKey = Deno.env.get('FCM_SERVER_KEY')
    if (!fcmServerKey) {
      return new Response('FCM_SERVER_KEY not set', { status: 500 })
    }

    const fcmRes = await fetch('https://fcm.googleapis.com/fcm/send', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `key=${fcmServerKey}`,
      },
      body: JSON.stringify({
        to: recipient.fcm_token,
        notification: {
          title: `New Message from ${senderName}`,
          body: subject,
        },
        data: {
          type: 'new_message',
          messageId,
          senderId,
        },
      }),
    })

    console.log('FCM response:', await fcmRes.text())
    return new Response('OK', { status: 200 })
  } catch (error) {
    console.error('Edge function error:', error)
    return new Response(error.message, { status: 500 })
  }
})
