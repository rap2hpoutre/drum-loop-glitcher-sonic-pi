# frozen_string_literal: true

binary_chunks = [1, 2, 2, 4, 4, 8, 16]
ternary_binary_chunks = [1, 2, 2, 3, 3, 4, 4, 6, 6, 8, 16, 24, 32]

define :glitch_none do |ctx| normal four_beats(ctx) end
define :glitch_reorder do |ctx| 4.times { normal one_beat_random(ctx) } end

define :glitch_binary_drill do |ctx| 4.times { |index| drill(one_beat(ctx, index), binary_chunks.choose) } end
define :glitch_ternary_drill do |ctx| 4.times { |index| drill(one_beat(ctx, index), ternary_binary_chunks.choose) } end
define :glitch_unordered_binary_drill do |ctx| 4.times { drill(one_beat_random(ctx), binary_chunks.choose) } end
define :glitch_unordered_super_slice_drill do |ctx| 8.times { drill(half_beat_random(ctx), ternary_binary_chunks.choose) } end
define :glitch_super_slice_drill do |ctx| 8.times { |index| drill(half_beat(ctx, index), ternary_binary_chunks.choose) } end

define :glitch_half_unordered_super_slice_drill do |ctx|
  8.times do |index|
    if one_in(2)
      drill(one_beat(ctx, index), binary_chunks.choose)
    else
      drill(half_beat_random(ctx), binary_chunks.choose)
    end
  end
end

define :glitch_super_slice_drill_last do |ctx|
  normal two_beats(ctx)
  4.times { drill(half_beat_random(ctx), ternary_binary_chunks.choose) }
end

define :glitch_reverse_last do |ctx|
  normal three_beats(ctx)
  reverse one_beat(ctx, 3)
end

define :glitch_something do |ctx|
  4.times { |index| something one_beat(ctx, index) }
end

define :glitch_two_bug_end do |ctx|
  slow one_beat(ctx, 0)
  normal two_beats(ctx, 1)
  something half_beat_random(ctx)
  something half_beat_random(ctx)
end

define :glitch_aphex do |ctx|
  normal three_beats(ctx)
  four_stairs_down one_beat(ctx, 3)
end

define :glitch_broken_start do |ctx|
  normal one_beat(ctx)
  normal half_beat(ctx, 1)
  normal one_beat(ctx)
  normal half_beat(ctx, 1)
  normal one_beat(ctx)
end

define :glitch_chop1 do |ctx|
  drill one_beat(ctx), 4
  drill one_beat(ctx, 1), 2
  normal one_beat(ctx, 2)
  slow one_beat(ctx)
end

define :glitch_cut do |ctx|
  8.times { |index| mute_half half_beat(ctx, index) }
end

define :glitch_cut_then_break do |ctx|
  6.times { |index| mute_half half_beat(ctx, index) }
  slow half_beat_random(ctx)
  drill half_beat_random(ctx), 16
end
