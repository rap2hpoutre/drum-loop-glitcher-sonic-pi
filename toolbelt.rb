# frozen_string_literal: true

define :slice do |ctx, start, finish|
  cursor = ctx[:current_bar] * ctx[:beats_per_bar]
  return {
    start: ((cursor + start).to_f / ctx[:beats_per_bar] / ctx[:bars_count]).round(10),
    finish: ((cursor + finish).to_f / ctx[:beats_per_bar] / ctx[:bars_count]).round(10),
    smp: ctx[:smp]
  }
end

define :one_beat do |ctx, start = 0| slice(ctx, start, start + 1) end
define :two_beats do |ctx, start = 0| slice(ctx, start, start + 2) end
define :three_beats do |ctx, start = 0| slice(ctx, start, start + 3) end
define :four_beats do |ctx, start = 0| slice(ctx, start, start + 4) end
define :half_beat do |ctx, start = 0| slice(ctx, start, start + 0.5) end
define :three_quarter_beat do |ctx, start = 0| slice(ctx, start, start + 0.75) end
define :one_beat_random do |ctx| one_beat(ctx, rrand_i(0, 3)) end
define :half_beat_random do |ctx| one_beat(ctx, (0..3.5).step(0.5).to_a.choose) end
define :duration do |s| (s[:finish] - s[:start]).to_f end

define :normal do |s|
  sample s[:smp], start: s[:start], finish: s[:finish]
  sleep duration(s)
end

define :reverse do |slice|
  normal({ start: slice[:finish], finish: slice[:start], smp: slice[:smp] })
end

define :drill do |slice, quantity|
  quantity.times do |_index|
    sample slice[:smp], start: slice[:start], finish: slice[:start] + duration(slice) / quantity
    sleep duration(slice) / quantity
  end
end

define :slow do |slice|
  sample slice[:smp], start: slice[:start], finish: slice[:start] + duration(slice) / 2, rate: 0.5
  sleep duration(slice)
end

define :fast do |slice|
  finish = slice[:start] + duration(slice) * 2
  sample slice[:smp], start: slice[:start], finish: finish > 1 ? 1 : finish, rate: 2
  sleep duration(slice)
end

define :four_stairs_down do |slice|
  4.times do |index|
    sample slice[:smp], start: slice[:start], finish: slice[:start] + duration(slice) / 4, rate: 1.5 - index / 8.0, amp: 0.8
    sleep duration(slice) / 4
  end
end

define :mute_half do |slice|
  sample slice[:smp], start: slice[:start], finish: slice[:start] + duration(slice) / 2
  sleep duration(slice)
end

define :mute_quarter do |slice|
  sample slice[:smp], start: slice[:start], finish: slice[:start] + duration(slice) / 4
  sleep duration(slice)
end

define :something do |slice|
  case dice(4)
  when 1 then reverse slice
  when 2 then drill slice, ternary_binary_chunks.choose
  when 2 then drill slice, ternary_binary_chunks.choose
  when 3 then mute_half slice
  when 2 then mute_quarter slice
  when 3 then slow slice
  when 2 then fast slice
  else slow slice
  end
end
