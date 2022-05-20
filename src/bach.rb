notes_bach = [[74, 0.5],
              [67, 0.25], [69, 0.25], [71, 0.25], [72, 0.25],
              [74, 0.5], [67, 0.5], [67, 0.5],
              [76, 0.5],
              [72, 0.25], [74, 0.25], [76, 0.25], [78, 0.25],
              [79, 0.5], [67, 0.5], [67, 0.5],
              [72, 0.5],
              [74, 0.25], [72, 0.25], [71, 0.25], [69, 0.25],
              [71, 0.5],
              [72, 0.25], [71, 0.25], [69, 0.25], [67, 0.25],
              
              [66, 0.5],
              [67, 0.25], [69, 0.25], [71, 0.25], [67, 0.25],
              [71, 0.5],[69, 1],
              
              [74, 0.5],
              [67, 0.25], [69, 0.25], [71, 0.25], [72, 0.25],
              [74, 0.5], [67, 0.5], [67, 0.5],
              [76, 0.5],
              [72, 0.25], [74, 0.25], [76, 0.25], [78, 0.25],
              [79, 0.5], [67, 0.5], [67, 0.5],
              [72, 0.5],
              [74, 0.25], [72, 0.25], [71, 0.25], [69, 0.25],
              [71, 0.5],
              [72, 0.25], [71, 0.25], [69, 0.25], [67, 0.25],
              
              [69, 0.5],
              [71, 0.25], [69, 0.25], [67, 0.25], [66, 0.25],
              [67, 1.5]
              ]
###########
use_bpm 90
b1 = spread(3,8)
b2 = spread(2,8)
b3 = spread(5,8)
puts b2

b1 = spread(3, 8)
b2 = spread(1, 8)
b3 = spread(3, 16)
live_loop :rythm do
  sample :bd_fat, amp: 0.7 if b1.tick(:b1)
  sample :tabla_ke1, amp: 0.4, rate: 0.8, cutoff: 100 if b2.tick(:b2)
  synth :noise, amp: rrand(0.4, 0.6), release: rrand(0.1,0.2), cutoff: (line 70, 85, steps:5).tick if b3.tick(:b3)
  sleep 0.25
end

live_loop :bass, sync: :rythm do
  synth :sine, note: 32, amp: 2, attack: 0, release: 0.4
  sleep 1
end

melody = markov_melody(12, notes_bach)
#melody = notes_bach
melody += melody.reverse

live_loop :melody, sync: :rythm do
  note = melody.tick
  synth :sine, note: note[0], amp: 0.7, release: 0.25
  sleep note[1]
end