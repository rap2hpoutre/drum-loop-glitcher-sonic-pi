# frozen_string_literal: true

rates_binary = [1, 2, 2, 4, 4, 8, 16]
rates_ternary_binary = [1, 2, 2, 3, 3, 4, 4, 6, 6, 8, 16, 24, 32]

define :base_drill do |beats_count, rates, beat_duration, smp, first_beat|
  beats_count.times do |beat_index|
    rate = rates.choose
    start = (beat_index.to_f + first_beat) * beat_duration
    slice_duration = beat_duration.to_f / rate
    finish = start + slice_duration
    rate.times do
      sample smp, start: start, finish: finish
      sleep slice_duration
    end
  end
end

define :binary_basic_drill_4bar do |smp|
  base_drill(4, rates_binary, 0.25, smp, 0)
end

define :ternary_binary_basic_drill_4bar do |smp|
  base_drill(4, rates_ternary_binary, 0.25, smp, 0)
end

define :ternary_binary_basic_half_drill_4bar do |smp|
  base_drill(1, [1], 0.25, smp, 0)
  base_drill(1, rates_ternary_binary, 0.25, smp, 1)
  base_drill(1, [1], 0.25, smp, 2)
  base_drill(1, rates_ternary_binary, 0.25, smp, 3)
end

define :unordered_drill_4bar do |smp|
  4.times { base_drill(1, rates_ternary_binary, 0.25, smp, (0..3).to_a.choose) }
end

define :unordered_super_slice_drill_4bar do |smp|
  8.times do
    base_drill(1, rates_ternary_binary, 0.125, smp, (0..7).to_a.choose)
  end
end

define :half_unordered_super_slice_4bar do |smp|
  4.times do |index|
    base_drill(1, [1], 0.125, smp, index)
    base_drill(1, [1], 0.125, smp, (0..7).to_a.choose)
  end
end

define :base_reverse do |beat_duration, duration, smp, first_beat|
  finish = first_beat * beat_duration
  start = finish + (duration * beat_duration)
  sample smp, start: start, finish: finish
  sleep beat_duration * duration
end

define :reverse_4bar do |smp, without_index = false|
  4.times do |index|
    base_reverse(0.25, 1, smp, without_index ? (0..3).to_a.choose : index)
  end
end

define :unordered_reverse_4bar do |smp|
  reverse_4bar(smp, true)
end

define :base_stretch do |beat_duration, duration, smp, first_beat, rate|
  start = first_beat * beat_duration
  finish = start + (beat_duration * duration)
  finish = 1 if finish > 1
  sample smp, start: start, finish: finish, rate: rate
  sleep duration / rate * beat_duration
end

define :slow_4bar do |smp|
  2.times do |_index|
    base_stretch(0.25, 1, smp, (0..3).to_a.choose, 0.5)
  end
end

define :glitchy_reverse_drill_stretch_4bar do |smp|
  4.times do |index|
    pos = index
    case dice(3)
    when 1
      base_drill(1, rates_ternary_binary, 0.25, smp, pos)
    when 2
      base_reverse(0.25, 1, smp, pos)
    when 3
      base_stretch(0.25, 0.5, smp, pos, 0.5)
    end
  end
end

define :glitchy_reverse_drill_stretch_super_slice_4bar do |smp|
  8.times do |index|
    pos = index
    case dice(5)
    when 1
      base_drill(1, rates_ternary_binary, 0.125, smp, pos)
    when 2
      base_reverse(0.125, 1, smp, pos)
    when 3
      base_stretch(0.125, 0.5, smp, pos, 0.5)
    when 4
      base_drill(1, [1], 0.125, smp, pos)
    when 5
      base_stretch(0.125, 2, smp, pos, 2)
    end
  end
end

define :base_fx do |beats_count, beat_duration, smp, _first_beat|
  beats_count.times do |index|
    with_fx %i[bitcrusher ixi_techno krush octaver pitch_shift ring_mod].choose do
      base_drill(1, [1], beat_duration, smp, index)
    end
  end
end

define :fx_4bar do |smp|
  base_fx(4, 0.25, smp, 0)
end

define :glitch_fixed_4bar do |smp|
  base_drill(1, [1], 0.25, smp, 0)
  base_drill(1, [1, 1, 2, 2, 2, 3, 3, 4, 8, 16, 24, 32], 0.25, smp, (0..3).to_a.choose)
  effects = %i[bitcrusher ixi_techno octaver pitch_shift tanh wobble flanger]
  with_fx effects.choose do
    if one_in(2)
      base_stretch(0.25, 0.5, smp, 2, 0.5)
    else
      base_drill(1, [1, 2, 4], 0.25, smp, 2)
    end
    case dice(3)
    when 1
      base_drill(1, rates_ternary_binary, 0.25, smp, 3)
    when 2
      base_reverse(0.25, 1, smp, 3)
    when 3
      base_stretch(0.125, 2, smp, 2, 2)
      base_stretch(0.125, 0.5, smp, 2, 0.5)
    end
  end
end

define :pitch_up_4bar do |smp|
  sample smp, start: 0, finish: 1, pitch: 4, amp: 1.2
  sleep 1
end

define :chop1 do |smp|
  base_drill(1, [4], 0.25, smp, 0)
  base_drill(1, [2], 0.25, smp, 1)
  base_drill(1, [1], 0.25, smp, 2)
  base_stretch(0.25, 0.75, smp, 3, 0.75)
end

define :chop2 do |smp|
  sample smp, start: 0, finish: 0.25, pitch: -4, amp: 1.2
  sleep 0.25
  sample smp, start: 0.25, finish: 0.5
  sleep 0.25
  base_drill(1, [1], 0.25, smp, 2)
  sample smp, start: 0.75, finish: 0.8
  sleep 0.25
end

define :base_cut do |smp, index|
  sample smp, start: index / 8.0, finish: index / 8.0 + 1 / 8.0 / 2
  sleep 1 / 8.0
end

define :cut_4bar do |smp|
  8.times do |index|
    base_cut(smp, index)
  end
end

define :cut_then_break_4bar do |smp|
  6.times { |index| base_cut(smp, index) }
  base_stretch(0.125, 0.5, smp, 2, 0.5)
  base_drill(1, [16], 0.125, smp, 7)
end

define :aphex_4bar do |smp|
  sample smp, start: 0, finish: 0.75
  sleep 0.75
  4.times do |index|
    sample smp, start: 0.75, finish: 0.85, rate: 1.5 - index / 8.0, amp: 0.8
    sleep 0.0625
  end
end

define :broken_start_4bar do |smp|
  length = 1 / 8.0 * 3.0
  sample smp, start: 0, finish: length
  sleep length
  sample smp, start: 0, finish: length
  sleep length
  sample smp, start: 0, finish: 0.25
  sleep 0.25
end

in_thread do
  loop do
    smp = [:loop_amen].choose
    use_sample_bpm smp

    sample smp
    sleep 1
    3.times do
      [
        method(:broken_start_4bar),
        method(:cut_then_break_4bar),
        method(:cut_4bar),
        method(:chop2),
        method(:chop1),
        method(:pitch_up_4bar),
        method(:glitch_fixed_4bar),
        method(:glitchy_reverse_drill_stretch_4bar),
        method(:glitchy_reverse_drill_stretch_super_slice_4bar),
        method(:fx_4bar),
        method(:binary_basic_drill_4bar),
        method(:glitchy_reverse_drill_stretch_4bar),
        method(:glitchy_reverse_drill_stretch_4bar),
        method(:half_unordered_super_slice_4bar),
        method(:slow_4bar),
        method(:aphex_4bar),
        method(:unordered_super_slice_drill_4bar),
        method(:unordered_reverse_4bar),
        method(:ternary_binary_basic_half_drill_4bar),
        method(:unordered_drill_4bar)
      ].choose.call(smp)
    end
  end
end

loop do
  # sample :drum_cowbell
  sleep 1
end
