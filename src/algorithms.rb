#
# This file contains all the utility functions that help you to generate rhythms
# and melodies.
#
# For generating rhythms we use Euclid's algorithm to distribute hits evenly
# within a number of beats, see http://cgm.cs.mcgill.ca/~godfried/publications/banff.pdf
#
# The melody is generated via a stochastic Markov-matrix (a transition matrix) which is first generated based on a given piece of music.
# Two pieces are available: Happy Birthday, (beginning of) Bach's Minuet in G.
# The algorithm computes the frequency of each transition for example from (C, half note) to (G, full note)
# and interpret these frequencies as probabilities.
# Based on the resulting transition matrix one can generate new pieces.
#


################ RHYTHMS GENERATION ##################
define :euclid do |k,n|
  #
  # k = number of hits that you want to place evenly within the n beats
  # n = number of beats
  #
  # the build-in function spread(k,n) does the same
  #
  sequences = Array.new(k, [1]) + Array.new(n-k, [0])
  while n != k
    if n > k
      n -= k
    else
      k -= n
    end
    
    pivot = [n,k].min
    if pivot <= 1 && sequences[sequences.length-1] != [0]
      break
    end
    len = sequences.length
    for i in 0..pivot-1
      sequences[pivot-1-i] += sequences.pop
    end
  end
  return sequences.flatten
end

define :arpeggio do |notes|
  #
  # generates a mirrowed arpeggio based on the notes
  #
  return ([notes[notes.length-1]-12]) + notes + [(notes[0]+12)] + notes.reverse
end

define :gen_ramp do |from, to, step|
  result = [from]
  while from <= to
    from += step
    result += [from]
  end
  return result
end
################ END GENERATION ##################

################ MELODY GENERATION ###############
define :gen_markov_matrix do |states, notes|
  #
  # Generates the transition matrix based on the set of notes (states)
  # and a given piece of music (notes).
  #
  matrix = Array.new(states.length, 0)
  
  for i in 0..(states.length-1)
    matrix[i] = Array.new(states.length, 0)
  end
  
  # (1) count transitions
  for i in 0..(notes.length-1)
    for from in 0..(states.length-1)
      for to in 0..(states.length-1)
        if notes[i] == states[from] && notes[i+1] == states[to]
          matrix[from][to] += 1.0
        end
      end
    end
  end
  # (2) normalize
  for from in 0..(states.length-1)
    s = matrix[from].sum
    for to in 0..(states.length-1)
      matrix[from][to] /= s
    end
  end
  print_matrix matrix, states
  return matrix
end

define :gen_mmelody do |n, matrix, start, states|
  #
  # Generates a random melody of length n based on a transition matrix
  # and an initial statenumber (start).
  #
  notes = [states[start]]
  from = start
  (n-1).times do
    p = rrand(0, 1)
    sum = 0
    to_row = matrix[from]
    to = 0
    while sum < p
      sum += to_row[to]
      to += 1
    end
    notes += [states[to-1]]
    from = to-1
  end
  return notes
end

define :gen_rmelody do |n, states|
  #
  # Generates a random melody from a given list of notes (states)
  #
  notes = []
  n.times do
    notes += [states[rand_i(states.length-1)]]
  end
  return notes
end

define :print_statistic do |notes|
  #
  # Debugging function that the frequencies of each note.
  #
  states = notes.uniq
  counts = Array.new(states.length, 0.0)
  for i in 0..(states.length-1)
    for note in notes
      if note == states[i]
        counts[i] += 1.0
      end
    end
  end
  
  for i in 0..(counts.length-1)
    counts[i] /= notes.length
  end
  print states
  print counts
end

define :print_matrix do |matrix, states|
  #
  # Debugging function that prints the transition matrix in a readable format.
  #
  print '############# Generated Markov Matrix:'
  for from in 0..(matrix.length-1)
    print states[from], ':',  matrix[from]
  end
  print '#############'
end

define :markov_melody do |n, notes|
  states = notes.uniq
  matrix = gen_markov_matrix(states.ring, notes.ring)
  return gen_mmelody(n, matrix, rand_i(states.length-1), states)
end
################ END MELODY GENERATION ###########

################ SONGS ###########################
# example piece of music:  (happy birthday)
notes_hb = [
  [:g4, 1.0/8], [:g4, 1.0/8], [:a4, 1.0/4], [:g4, 1.0/4],
  [:c5, 1.0/4], [:b4, 1.0/2],
  [:g4, 1.0/8], [:g4, 1.0/8], [:a4, 1.0/4], [:g4, 1.0/4],
  [:d5, 1.0/4], [:c5, 1.0/2],
  [:g4, 1.0/8], [:g4, 1.0/8], [:g5, 1.0/4], [:e5, 1.0/4],
  [:c5, 1.0/4], [:b4, 1.0/4], [:a4, 1.0/4],
  [:f5, 1.0/8], [:f5, 1.0/8], [:e5, 1.0/4], [:c5, 1.0/4],
  [:d5, 1.0/4], [:c5, 1.0/2]
]

# example piece of music: (beginning of) Bach's Minuet in G.
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
################ SONGS ###########################


#use_bpm 60
#notes = markov_melody(12, notes_bach)
#notes = notes_bach

#live_loop :piano do
#  use_synth :piano
#  play notes.tick[0], release: notes.look[1]*1.3
#  sleep notes.look[1]
#end
#puts euclid(11, 24)
