use_bpm 120
sc = scale(:G, :minor)

chords = ring(
  [chord(:Eb3, :major7), 4],
  [chord(:G3, :minor), 6],
  [chord(:D3, :minor), 2]
)

live_loop :theme do
  if tick % 3 == 0
    cue :go
  end
  note = chords.look
  rel = note[1]*1.3
  with_fx :reverb, room: 1 do
    player = synth :fm, note: note[0], amp: 1.0, release: rel, depth: 2, cutoff: rrand(56, 70), cutoff_slide: rel
    control player, cutoff: 10
  end
  sleep note[1]
end

live_loop :rythm, sync: :go do
  sample :bd_fat, amp: 1.0 if spread(3,8).tick
  sample :tabla_ke1, amp: 0.4, rate: rrand(0.8, 0.75) if spread(1,8).look
  synth :cnoise, amp: 0.6, release: rrand(0.1, 0.2), cutoff: rrand(75, 80) if spread(3,8).look
  sleep 0.25
end

mybeat = spread(13, 40) + Array.new(40, false)
live_loop :melody, sync: :go do
  stop
  note = chords.tick
  (note[1]*4).times do
    amp = ramp( *line(1, 0, steps: 40)).tick(:amp)
    with_fx :reverb, room: 1 do
      synth :piano, note: note[0].look(:beat), amp: amp, pitch: 24, release: 1.3 if mybeat.tick(:beat)
    end
    sleep 0.25
  end
end