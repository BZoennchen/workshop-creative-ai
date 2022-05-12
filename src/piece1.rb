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


use_random_seed 42
use_bpm 128

beats = euclid(5,8)
sc = scale(:c, :major, num_octaves: 5)
slow_melo = shuffle gen_minor(3, 0)

live_loop :drums do
  sample :bd_fat, rate: 1.5, cutoff: 80, amp: 2 if beats.tick == 1
  sleep 0.5
end

live_loop :slow_melo, sync: :drums do
  with_fx :reverb do
    synth :fm, note: sc[slow_melo.tick]-24, sustain: 4, amp: rrand(0.9, 0.7), pan: rrand(-0.6, 0.6)
    sleep 4
  end
end

live_loop :clap, sync: :drums do
  sample [:perc_snap2, :perc_snap2, :perc_swoosh].tick, amp: 0.3, rate: rrand(1.3, 1.4)
  sleep 1.5
  synth :gnoise, amp: 1.3, cutoff: rrand(75, 85), sustain: 0, release: rrand(0.3, 0.5)
  sleep 0.5
end

melody = markov_melody(12, notes_bach)

live_loop :test, sync: :drums do
  synth :fm, note: melody.tick[0], release: melody.look[1]*1.3
  sleep melody.look[1]*4
end

melody2 = gen_minor(6, 0)
melody_beats2 = euclid(3,64)
live_loop :test2, sync: :drums do
  if melody_beats2.tick(:tbeat) == 1
    with_fx :panslicer do
      #with_fx :slicer do
      synth :growl, note: to_chord(melody2.tick(:tmelody), sc, 12), attack: 3, release: 6, amp: 3
      #end
    end
  end
  sleep 0.25
end