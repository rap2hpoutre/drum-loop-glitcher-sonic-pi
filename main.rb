# frozen_string_literal: true

glitches_smooth = [
  :glitch_none,
  :glitch_binary_drill,
  :glitch_reorder,
  :glitch_reverse_last,
  :glitch_chop1,
  :glitch_cut,
  :glitch_xit,
]
glitches_hard = [
  :glitch_binary_drill,
  :glitch_ternary_drill,
  :glitch_unordered_binary_drill,
  :glitch_unordered_super_slice_drill,
  :glitch_super_slice_drill,
  :glitch_half_unordered_super_slice_drill,
  :glitch_super_slice_drill_last,
  :glitch_something,
  :glitch_two_bug_end,
  :glitch_aphex,
  :glitch_broken_start,
  :glitch_cut_then_break,
  :glitch_end_something,
  :glitch_fx_end,
  :scratch
]
glitches_all = glitches_smooth + glitches_hard

loops = [
  { bars_count: 1, data: [:loop_amen, :loop_electric, :loop_mehackit2] },
  { bars_count: 2, data: [:loop_compus] },
  { bars_count: 4, data: [:loop_garzul, :loop_garzul, :loop_safari, :loop_mika, :loop_amen_full ] }
]
use_random_seed 99
loops.each do |item|
  item[:data].each do |current_data|
    use_sample_bpm current_data
    indices = (0..(item[:bars_count] - 1)).to_a.ring
    ((0..3).to_a * 2).each do |index|
      ctx = { beats_per_bar: 4, bars_count: item[:bars_count], current_bar: indices[index], smp: current_data }

      current = :glitch_none if index == 0
      current = glitches_all.choose if index == 1 || index == 3
      current = glitches_smooth.choose if index == 2
      puts current, index, indices[index], ctx
      method(current).call(ctx)
    end
  end
end
