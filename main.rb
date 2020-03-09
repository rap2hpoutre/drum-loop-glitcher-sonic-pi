# frozen_string_literal: true

glitches_smooth = [method(:glitch_none), method(:glitch_binary_drill)]
glitches_hard = [
  method(:glitch_unordered_binary_drill),
  method(:glitch_aphex), 
  method(:glitch_broken_start)
]
glitches_all = glitches_smooth + glitches_hard

loops = [
  { bars_count: 1, data: [:loop_amen] },
  { bars_count: 2, data: [:loop_compus] },
  { bars_count: 4, data: [:loop_amen_full] }
]

loops.each do |item|
  item[:data].each do |current_data|
    use_sample_bpm current_data
    indices = (0..(item[:bars_count] - 1)).to_a.ring
    8.times do |index|
      ctx = { beats_per_bar: 4, bars_count: item[:bars_count], current_bar: indices[index], smp: current_data }
      glitch_none ctx if index == 0
      glitches_all.choose.call(ctx) if index == 1
      glitches_smooth.choose.call(ctx) if index == 2
      glitches_all.choose.call(ctx) if index == 3
    end
  end
end
