#!/usr/bin/env ruby

require 'set'

class WordleBot
  def initialize
    @dict = DATA.map { |line| line.strip! }
    @words = Set.new(@dict)
  end

  def _start
    @guess = nil
    @words = Set.new(@dict)
    @frame = Array.new(5) { Set.new('a'..'z') }
    @match = Set.new()
  end

  def _update(result)
    guess = @guess.split("")
    result = result.split("")
    result.each.with_index do |letter, i|
      next unless guess[i].upcase == letter
      @frame[i] = Set.new([guess[i]])
      @match << guess[i]
    end
    result.each.with_index do |letter, i|
      next unless letter == "*"
      @frame.each { |frame| frame.delete(guess[i]) if frame.length > 1 }
    end
    result.each.with_index do |letter, i|
      next unless guess[i] == letter
      @frame.each { |frame| frame << guess[i] unless frame.length == 1 }
      @frame[i].delete(guess[i])
      @match << guess[i]
    end
    result.each.with_index do |letter, i|
      next unless letter == "*"
      @frame[i].delete(guess[i])
    end
    # puts @frame
    @words.delete_if do |word|
      check = Set.new(word.split(""))
      keep = @match.all? { |letter| check.include?(letter) }
      @frame.each.with_index do |frame, i|
        keep &= frame.include?(word[i])
        break unless keep
      end
      !keep
    end
  end

  def _guess(start)
    return "arose" if start
    scores = Hash.new
    total = 0.0
    @words.each do |word|
      value = 0.0
      @words.each { |guess| value += _value(guess, word) }
      scores[word] = value
      total += value
    end
    average = total / @words.length
    guesses = []
    scores.each do |word, value|
      guesses << word if value >= average
    end
    guesses.first
  end

  def game(id)
    ANSWERS[id]
  end

  def play(result = nil)
    result.nil? ? _start : _update(result)
    @guess = _guess(result.nil?)
  end

  def score(guess, secret)
    result = ['*', '*', '*', '*', '*']
    guess = guess.split("")
    secret = secret.split("")
    guess.each.with_index do |letter, i|
      next if letter == "*"
      next unless letter == secret[i]
      guess[i] = "*"
      secret[i] = "*"
      result[i] = letter.upcase
    end
    guess.each.with_index do |letter, i|
      next if letter == "*"
      secret.each.with_index do |other, j|
        next unless letter == other
        guess[i] = "*"
        secret[j] = "*"
        result[i] = letter
      end
    end
    result.join
  end

  def _value(guess, secret)
    value = 0
    score(guess, secret).split("").each do |letter|
      value += 1 unless letter == '*'
    end
    value
  end
end

answers = File.read("answers.txt").split("\n").map(&:strip)
answers.each.with_index do |secret, i|
  wordlebot = WordleBot.new
  guess = wordlebot.play
  grid = []
  count = 0
  loop do
    count += 1
    score = wordlebot.score(guess, secret)
    emoji = []
    score.split("").each do |letter|
      if letter == "*"
        emoji << '⬛'
      elsif letter.upcase == letter
        emoji << '🟩'
      else
        emoji << '🟨'
      end
    end
    grid << emoji.join
    break if guess.upcase == score
    guess = wordlebot.play(score)
  end
  puts "Wordle #{i} #{count}/6\n"
  grid.each { |line| puts line }
  puts ""
  break if i > 212
end

exit

wordlebot = WordleBot.new
guess = wordlebot.play
secret = ARGV.first
loop do
  if secret.nil?
    puts guess
    print "> "
    score = gets.strip
  else
    score = wordlebot.score(guess, secret)
    puts "#{guess} | #{score}"
  end
  break if guess.upcase == score
  guess = wordlebot.play(score)
end

__END__
which
their
there
would
other
these
about
first
could
after
those
where
being
under
years
great
state
world
three
while
found
might
still
right
place
every
power
since
given
never
order
water
small
shall
large
point
again
often
among
house
women
group
think
human
later
until
whole
early
means
above
value
study
table
taken
times
known
court
young
words
white
light
least
level
child
death
press
cases
going
party
using
sense
based
whose
south
total
class
local
along
terms
money
black
force
north
night
short
field
asked
quite
thing
woman
major
third
shown
began
cause
heart
seems
trade
clear
model
lower
close
blood
hands
story
forms
paper
works
areas
parts
union
river
books
space
price
makes
basis
alone
below
earth
heard
lines
hours
range
truth
board
needs
front
shows
leave
cells
march
doing
stage
today
labor
voice
bring
peace
chief
added
issue
equal
india
basic
types
music
james
wrote
sound
ideas
final
miles
rules
gives
cross
moral
faith
legal
comes
civil
built
round
scale
write
doubt
seven
costs
green
takes
image
plant
speak
lives
paris
tried
china
upper
eight
henry
stock
stand
share
style
start
goods
ready
occur
notes
rates
stood
jesus
moved
staff
brown
lived
learn
daily
allow
noted
names
phase
hence
heavy
fully
title
claim
fixed
facts
color
begin
event
month
offer
wrong
carry
serve
weeks
stone
royal
trust
units
trees
drawn
floor
smith
glass
judge
enemy
japan
piece
reach
meant
visit
enter
worth
roman
cover
forth
avoid
mouth
exist
steps
views
spent
scene
brain
shape
happy
older
trial
plans
sales
usual
prior
apply
horse
speed
index
birth
ought
named
error
joint
focus
peter
girls
queen
urban
bound
tests
kinds
greek
coast
plate
check
walls
break
ratio
sides
sight
media
broad
agent
aware
youth
pages
sleep
items
fresh
knows
drive
rural
metal
guide
steel
banks
spoke
grand
apart
prove
fight
fifty
grant
brief
solid
false
funds
forty
build
ideal
lands
signs
rapid
crime
inner
limit
calls
plane
novel
louis
adult
block
store
layer
plain
maybe
watch
count
touch
grace
proof
agree
crown
spain
radio
leads
looks
train
input
minor
motor
depth
ships
wants
mixed
cycle
sites
curve
angle
goals
heads
dream
entry
birds
frame
grown
sugar
unity
firms
owner
truly
loved
taxes
yield
chair
tools
hotel
thick
fluid
refer
fifth
fruit
raise
quiet
twice
taste
worse
drugs
chain
plays
clean
towns
spite
sharp
bible
shift
waste
ahead
prime
grade
frank
aside
sweet
wages
drink
minds
begun
texas
extra
noise
guard
favor
quick
nerve
rooms
skill
ocean
tells
ended
logic
enjoy
teeth
finds
empty
route
thank
lying
acute
smile
armed
rocks
dance
jones
falls
broke
sheet
noble
dress
teach
spend
phone
print
scope
slave
stars
tasks
grain
honor
arise
hills
exact
holds
owned
reply
bread
waves
alive
theme
cited
turns
glory
saint
vital
roots
poems
grass
outer
tears
bonds
homes
marks
faced
faces
track
dutch
abuse
shore
gross
steam
negro
delay
hoped
pride
treat
texts
grave
admit
cloth
crowd
files
users
roles
uncle
roads
chest
saved
score
cried
flesh
blind
anger
essay
fault
canal
click
kings
rough
habit
sorry
lewis
shock
catch
moves
liver
verse
games
beach
worst
reign
films
shell
songs
valid
doors
trace
sixty
liked
fever
nurse
throw
bones
drama
naval
corps
storm
match
woods
owing
smoke
fleet
hopes
wheat
argue
loose
newly
guess
trans
organ
sheep
cards
angry
topic
feels
mount
dying
crops
trend
acted
tower
loans
tends
helps
sixth
lists
dated
males
acres
proud
shook
split
acids
width
wound
harry
chart
chose
wheel
drove
flows
tired
draft
dozen
wider
yards
creek
threw
solve
alike
panel
dealt
links
sword
magic
modes
souls
gifts
marry
bills
stick
paint
fewer
seeds
virus
yours
video
arose
adopt
foods
dates
urged
inter
mercy
slope
risks
maria
pulse
wives
atoms
wings
devil
clerk
tract
pound
laugh
boats
poets
worry
mines
bears
cloud
midst
opera
gains
merit
trail
array
realm
lords
shoes
fears
wales
stuff
valve
pairs
holes
serum
solar
bands
mayor
cable
ranks
basin
tribe
lunch
guilt
fatal
mills
moses
bases
votes
fired
dried
photo
usage
farms
tight
aimed
tumor
fancy
borne
ruled
edges
pupil
alter
pilot
award
fails
wells
gates
genes
sorts
blame
urine
tales
giant
cream
burst
flood
clock
seats
grows
movie
anglo
knife
badly
ridge
rigid
lover
keeps
races
renal
rises
prize
pitch
filed
eager
knees
sizes
angel
smell
cents
soils
sport
boxes
lakes
grief
winds
flame
deals
brand
actor
tubes
shame
label
brave
lease
mouse
naked
brick
truck
diary
cheap
craft
fiber
amino
seeks
norms
shops
shade
ports
decay
blank
teams
elder
grasp
elite
guest
piano
cease
prose
paths
strip
rival
asset
baker
imply
widow
supra
codes
zones
cruel
brush
roger
graph
poles
laser
vague
apple
shirt
debts
spots
crude
drops
deeds
swept
ghost
posts
talks
oxide
trunk
gases
altar
alarm
ruler
shoot
opens
onset
shaft
alien
hired
globe
swift
rings
clubs
dense
lodge
veins
spare
tenth
dirty
reads
pains
buyer
slide
stuck
arrow
tries
loves
coach
bench
rests
juice
voted
nodes
doses
stern
cabin
flour
bacon
tough
flash
pause
camps
lungs
humor
honey
meets
haven
aging
bride
fires
brass
faint
charm
ample
loyal
chase
upset
steep
crack
meals
ninth
tooth
eaten
smart
feast
maker
lucky
burns
caste
exile
forum
ruins
draws
quote
fraud
shake
sandy
slept
ralph
awful
genus
drunk
hated
rocky
tanks
toxic
super
quest
crazy
cargo
panic
limbs
utter
civic
harsh
lined
baron
shear
delta
siege
alpha
drift
peers
risen
loads
skull
walks
funny
swing
salts
canon
stake
stops
parks
fence
mason
gland
blade
alert
climb
coins
chaos
tones
boots
monks
cheek
sized
nancy
hurry
petty
mucky
stamp
spine
react
flies
snake
pipes
spell
meter
rolls
vivid
cared
plots
suite
burnt
evils
stems
straw
drain
beast
suits
weary
stiff
beans
dodgy
olive
likes
trips
thumb
sheer
vapor
polar
cubic
swiss
wagon
eagle
rifle
orbit
balls
cries
aided
awake
billy
tense
cohen
query
hardy
comic
pearl
skimp
fatty
shelf
peaks
vocal
beams
chile
drill
kelly
unite
rites
audit
bicep
focal
pious
deity
freed
frost
sends
screw
wires
elect
unzip
aloud
loses
probe
turks
burke
posed
abbey
basal
breed
weber
sweat
folks
laura
piety
patch
beard
homer
trick
genre
gauge
grove
tweet
dwell
rebel
pooch
creed
myths
quasi
erect
vitro
bused
donor
drank
spray
bloom
shots
dairy
audio
fetal
stack
sauce
blown
adapt
dared
folly
verbs
emcee
heirs
micro
exert
waist
seize
arena
gnash
sweep
token
artsy
curse
sexes
lofty
curvy
ether
linen
dread
rated
marsh
porch
lamps
wrath
irony
villa
nasal
roses
silly
prone
hosts
fairy
blast
wimpy
cliff
bells
bless
gassy
ashes
robin
elbow
pagan
backs
sided
welsh
elide
trait
penny
papal
jimmy
barry
lacks
botch
crash
plier
blows
moist
flora
woozy
belly
rents
rabbi
venus
hunky
float
crest
wrist
perry
relax
merry
jerry
parer
sally
ranch
swung
girly
faded
colon
epoch
knock
alloy
nails
cured
optic
bosom
booth
minus
daddy
bunch
wills
bowed
paste
flock
ferry
scots
heels
punch
weigh
tiger
horns
tours
corer
lemon
cares
spark
steal
fibre
macro
lymph
trout
johns
ivory
carol
sober
theft
baler
nicht
locus
waved
laden
crust
axial
avail
pedro
flung
gamma
lever
swear
twins
haste
grams
sadly
agony
costa
stain
beads
stove
stout
yeast
choir
skins
couch
halls
terry
folds
bowel
viral
purse
twist
betty
finer
psalm
blend
witch
abled
brook
maize
radar
sands
woven
worms
shine
penal
blues
coats
privy
hints
slain
sperm
plunk
newer
intra
hears
flank
canoe
pools
weeds
coral
opium
naive
crane
assay
shout
bliss
abbot
cough
sinus
atlas
hello
wiped
batch
chips
bombs
rains
gazed
seals
resin
manor
fills
hairs
salad
whiny
pumps
infer
modem
stark
lobby
oscar
palms
mound
craig
stare
heath
sworn
thine
overt
flags
berry
whale
herbs
monte
bored
sells
lipid
mould
vowel
pants
rhine
congo
nosey
setup
sunny
peril
stein
cloak
shone
cutie
graft
flint
ionic
scent
rider
inlet
tents
madam
skirt
piles
ditch
bonus
noisy
fiery
excel
baths
wines
torah
slice
drums
riots
undue
shalt
chang
basil
queer
beats
troop
taxed
fungi
loops
hymns
motif
chalk
ounce
gonna
thief
brace
locks
roofs
creep
safer
blunt
swell
candy
plaza
ultra
spear
wears
stays
gloom
chill
vigor
fetus
medal
goats
tombs
guild
album
hedge
chord
clues
watts
jokes
nouns
baked
sails
slate
tidal
joins
jenny
caves
tommy
boast
edema
abode
scorn
crews
stole
thigh
tutor
ankle
brake
fetch
rails
lions
masks
swamp
lapse
stool
relay
cheer
forts
tyler
slurp
await
cedar
onion
quota
jesse
fines
flush
vices
skies
digit
renew
penis
arbor
infra
piled
wedge
scrap
fauna
alley
clash
bobby
demon
fuzzy
crush
coils
nazis
feeds
traps
wreck
spoon
hides
dwelt
crept
drake
maxim
fanny
knots
fused
colin
ulcer
coded
herds
sects
nests
rainy
amend
synod
handy
cites
birch
fuels
goose
raids
tails
lasts
volts
hasty
abide
tenor
rally
buses
isles
casts
tapes
ropes
hatch
flask
dusty
robes
lance
robot
paved
poses
plead
clung
vault
cakes
email
merge
greed
fried
prima
recut
belle
wards
molly
proxy
diets
dogma
ethic
vines
bolts
fools
polls
shale
algae
ozone
voter
armor
molar
slosh
depot
lunar
belts
guise
logan
pines
maple
kills
tiles
timid
manly
greet
dover
niece
cigar
zesty
disks
spoil
risky
annex
weird
muddy
tempo
lyric
natal
unfit
revue
queue
vicar
edged
dwarf
tides
surge
swore
moods
mules
lotus
whigs
rhyme
comte
rotor
raven
torch
wiser
towel
binds
dough
flats
hangs
grape
dodge
twain
motto
camel
verge
brute
cords
cocoa
aorta
attic
cache
downs
lynch
ducks
awoke
toast
inert
sings
hooks
forge
saith
seine
jeans
ducts
flute
folio
urges
ponds
chess
tonic
derby
bluff
danny
niche
truce
blond
pills
slips
pulls
squad
pores
stray
lobes
tread
rides
avant
bowls
crisp
repay
flown
teens
saves
spies
prism
trash
nasty
glare
rouge
amber
donna
typed
fizzy
cleft
boost
slack
pratt
tires
wares
ditto
libel
groom
morse
aisle
terra
scout
cysts
ovary
frail
vogue
denis
cones
edict
coals
fritz
metre
stall
picks
modal
scalp
goner
steer
jewel
mater
anode
nerdy
bates
salon
woody
shiny
pleas
knelt
pinch
bytes
moody
fable
notch
diode
reins
miner
kebab
thorn
tuned
oaths
cling
lanes
assam
stalk
dined
needy
cagey
tying
stony
amply
stead
evoke
sinks
pasha
roast
spike
piers
liter
gangs
bitch
comet
syrup
idols
bleak
deter
chant
pests
riley
sigma
witty
holly
quart
jolly
lifts
petit
scars
lends
yacht
carts
tunes
diane
lumen
paddy
waged
blaze
plank
bulls
frogs
ethyl
toxin
weave
chuck
cores
bulbs
dummy
mamma
beset
stump
brink
sewer
chick
peach
daisy
buddy
mates
claws
eased
donne
jelly
mucus
waits
gorge
clans
tacit
logos
santo
moors
discs
slabs
crawl
incur
raced
broth
idiot
vista
docks
socks
genoa
germs
oddly
sting
envoy
popes
necks
rumor
scare
sages
swine
abyss
brood
niger
shark
kitty
badge
ethos
ledge
genet
wharf
enact
dolls
polly
geese
axion
satin
droit
idiom
peggy
gaffe
heaps
mecca
clays
apron
aloof
karma
icons
meats
larva
monde
vegas
rusty
humid
leone
scrub
crank
blush
scant
pixel
hairy
reset
shunt
hazel
paces
sheds
packs
bland
sacks
gleam
rouse
fists
cures
judas
circa
metro
gears
jumps
hurts
glove
brisk
stale
reefs
dimly
temps
mania
laity
twigs
menus
spill
timed
wired
taboo
bends
pouch
facet
hicks
flaws
decks
welch
axiom
purge
spasm
pizza
vases
amuse
clamp
maids
spans
strap
levin
dunes
lambs
sears
hobby
barge
shrub
friar
teddy
hates
devon
pivot
noses
warns
grind
aides
razor
godly
bites
hinge
evade
frown
fumes
fined
paced
doris
helix
curls
slots
avert
fairs
cooks
ester
cheat
fossa
stunk
seams
gloss
brows
savoy
nylon
pesos
baton
farce
pence
femur
forks
debit
raged
broom
align
recur
shady
spurs
glaze
cults
swarm
adobe
vinyl
liner
rubin
fares
alias
aloft
curry
perch
steak
bucks
haunt
snowy
flare
poker
comma
parry
ching
stair
famed
curly
quilt
sabha
puppy
beech
reeds
aptly
sieve
freer
lowly
venue
mined
gauze
scans
motel
vowed
chaps
gypsy
spice
ferns
havoc
palsy
relic
exams
milky
cubes
triad
bulky
kappa
piper
timer
mirth
pasta
romeo
lucid
willy
leaps
linux
moose
erase
clown
slums
iliac
dukes
irons
adept
clips
plume
looms
glide
giver
dowry
odour
defer
crook
tramp
debut
proto
drown
usher
bales
tonal
spake
pedal
plump
homme
scarf
moles
opted
bribe
desks
mourn
silva
slang
ensue
melts
semen
mimic
mural
iliad
bleed
ceded
hydro
tibia
vexed
expel
radii
filth
viola
duchy
repel
stoic
fixes
froze
dizzy
gotta
swami
lupus
shewn
tempt
datum
trays
laird
flaps
hawks
dolly
latex
leaks
spade
lakhs
rinse
hound
rogue
reuse
snack
mores
gaunt
boron
regal
groan
yates
padre
mails
omega
booty
bathe
axons
mixer
equip
molds
obese
grill
pears
foxes
sloan
starr
fermi
franc
codex
shawl
lumps
sighs
sutra
bully
patio
grips
heats
smear
argon
feats
bower
snail
widen
leach
feces
randy
taper
liber
anion
fated
choke
finch
valor
bantu
crabs
paolo
misty
raped
oasis
whore
intel
mains
junta
brine
brock
fowls
kerry
pluck
mummy
chili
crows
cages
adorn
venom
unset
salle
scand
fonts
moths
hilly
plugs
kirby
smoky
barns
odors
leapt
props
manic
mixes
parti
truss
soles
torso
pater
exits
canto
otter
lawns
comer
rigor
nodal
spore
ramen
dusky
grate
brent
masts
muses
adore
clone
cadre
emery
windy
rouen
aroma
loopy
matey
slick
stung
nexus
boxer
verso
benny
smash
actin
kneel
shire
chasm
tally
tunic
leafy
waldo
hogan
wafer
glued
tufts
mover
spins
shaky
fared
adieu
fling
gowns
aught
domes
nobly
serfs
snare
latch
shave
parma
writs
foley
mists
rugby
tiers
laced
phage
earns
slant
shack
tweed
aunts
fades
tinge
waltz
amiss
gills
heron
snuff
trois
epoxy
stoop
taped
purer
lemma
wight
earls
cafes
aspen
sahib
sneak
combs
pours
sores
clued
senor
mommy
spire
cider
tolls
boils
norma
deems
masse
tints
hitch
didst
cater
tithe
gaily
muted
liege
gable
dumas
silks
forte
loser
patty
dares
prays
valet
snows
scary
amour
wakes
shrug
poppy
quail
dazed
clasp
diver
ulnar
cadet
truer
telex
drier
zeros
mused
berth
sammy
leans
petri
beers
erred
waxed
magma
sling
scoop
slash
litre
geeky
sedan
humus
fecal
yarns
carve
trump
forme
hertz
sable
lathe
bulge
wager
liang
racks
retch
bison
chunk
torts
ovens
decor
pluto
slung
theta
ardor
doped
hoard
modus
causa
sloop
lured
slump
shiva
amine
mafia
moons
brill
rajah
wield
tease
grids
zaire
usury
femme
clump
squat
scram
leben
summa
fates
ariel
buggy
gauss
darcy
sleek
dower
sever
malik
steed
rowed
groin
gulls
moder
goths
whirl
ruddy
omits
campo
rover
colic
hoist
toned
poked
doves
hotly
mango
tenet
brunt
babel
mites
slows
sonny
macon
jails
kraft
liens
freak
siren
speck
rarer
taint
poise
olden
horde
elegy
totem
messy
remit
slime
fries
braid
cocks
abram
grail
vigil
flake
ached
casas
frock
rowan
login
studs
nymph
hyper
beaux
beets
hurst
kicks
porta
eerie
cours
cupid
waive
abate
dryer
redox
snout
darts
fuses
ticks
bushy
slits
mitch
pangs
anima
alkyl
carte
salty
wrung
avian
wasps
plumb
sneer
quill
allay
juror
blink
ebony
fitch
madly
jihad
cisco
butts
spicy
abbas
azure
keyed
canes
shews
harem
pubic
inset
voids
bravo
hoofs
eaves
firth
vodka
hades
anvil
vichy
burgh
livre
loins
asses
ayres
gully
canst
paler
nosed
lilac
camus
silky
lysis
solon
panes
hunts
heave
fours
cilia
primo
shove
unify
sheen
celts
haute
soaps
algal
dixie
leech
crave
dandy
exalt
harms
prick
curie
annoy
vomit
longs
carta
butte
cello
cowan
feuds
chute
sykes
agile
colds
amity
budge
fleas
chaff
eater
polio
bough
etude
navel
obeys
towed
epics
barre
sewed
giddy
tween
aired
aback
gaudy
rayon
cobra
blest
plums
xerox
laval
serge
nizam
honda
cotta
swans
staid
wraps
vagus
hover
toils
knoll
rupee
dingy
graze
bunny
melon
posse
crypt
lorry
whims
rhone
husky
acton
tasty
ramus
veils
elude
alder
banco
pharm
dries
bouts
roach
visas
volta
squid
nawab
spawn
arson
fugue
winch
foyer
admin
soups
tamed
lowry
mares
renin
nanny
oiled
tiled
shank
roper
thyme
pinto
setae
revel
whips
zonal
rivet
paras
yells
stirs
ripen
jacks
lousy
bumps
taxis
flair
argus
clams
smack
reddy
vents
folic
calyx
deans
gamut
bowie
chops
smelt
auger
lurid
showy
levee
murky
islet
dykes
cuffs
reeve
warts
twine
heady
wanna
vulva
frees
posit
joked
khaki
smuts
gales
gourd
garth
sonic
shorn
juicy
rafts
spelt
shuts
fiend
emits
payee
dives
credo
gravy
curia
dikes
beige
wilds
aches
crate
plied
swirl
chert
dived
lacey
stunt
stint
horny
knack
slade
tonga
swain
puffs
wally
endow
piped
boozy
croft
strut
butyl
sloth
leash
bleep
waned
spout
titan
cools
blocs
mayan
aegis
spied
scala
colby
reels
passe
mirza
sully
casks
doric
zebra
serra
tardy
manna
arias
flick
clove
inept
lusts
nihil
dumps
loath
aster
growl
tawny
stent
craze
champ
noyes
surat
babes
apres
bevel
clout
kilns
seton
merle
hives
mogul
smote
tilly
diner
erode
bolus
quell
tanto
nadir
grabs
hares
tasso
afoot
aural
intro
pease
apnea
atone
banal
radon
turbo
waugh
burly
afore
knobs
hoops
terse
largo
coles
boxed
hires
clint
foggy
debug
sybil
polis
chore
mated
seers
rorty
quoth
vitae
raked
wrest
gyrus
cacao
omens
potts
dames
durst
patsy
brant
tarry
slimy
stink
bards
tulip
ochre
limbo
alibi
icing
prune
hough
shoal
quark
sodom
girth
payer
pints
erica
bugle
manet
taker
adage
fangs
roost
busts
quine
gated
monty
borax
servo
bikes
tubal
corey
ileum
loess
suing
flyer
platt
mimeo
phony
atman
ducal
gusto
stave
drone
grunt
trier
plaid
mille
leper
livid
septa
spurt
quant
calif
enema
drags
croup
butch
bogus
stoke
nicer
dryly
bayou
hydra
domed
wiles
donee
bayer
memos
tuber
sabre
tusks
libri
abort
adder
horst
acorn
sills
arras
plush
tongs
snell
momma
easel
madre
lusty
sonar
bonne
acrid
minas
leger
sniff
skate
disco
froth
hulls
thump
nitro
conte
whine
delft
diced
nelly
clots
stile
dicta
noose
cramp
spool
lexis
bundy
leaky
scaly
hasta
miser
ponce
onely
affix
heals
moray
matte
savvy
stats
robed
macho
bursa
genie
trope
villi
glial
sheaf
bared
booms
trite
ilium
sacra
hunch
vials
whisk
titer
hoary
meted
mulch
knave
apace
pubis
crags
banda
walla
amide
helms
mumps
liars
petal
xylem
taunt
sawed
waded
welds
binge
sowed
hoods
frere
pussy
sieur
louie
beget
madge
snaps
barks
gazes
caged
usurp
ponty
derry
massa
mitre
shrew
beryl
riggs
meuse
savor
limes
shyly
downy
coups
nomad
quack
tabor
hanks
musty
jours
malls
thugs
toads
skunk
saute
jeune
oases
booze
morel
surer
rodeo
squaw
throb
bingo
mossy
gusts
vests
waite
scold
dimer
forgo
ortho
areal
lavas
quits
laces
codon
rebus
divan
joule
annul
chefs
ceres
bayes
banjo
glint
chico
amman
alamo
agate
munch
erupt
cynic
grist
grout
lough
jaffa
scour
cline
surly
eases
slugs
yearn
jetty
nabob
mower
spina
crick
dials
pikes
waxes
fides
ovate
shred
kinda
hales
odium
rages
salve
dregs
sited
jerks
bangs
abhor
warms
ingot
talus
scion
fanon
sangh
highs
guile
goody
etats
stork
gipsy
tepid
lisle
sakes
ladle
conch
larch
marge
fleur
autos
crore
tyres
jumbo
ginny
moans
moira
bores
legge
saber
frith
demos
wring
spate
bight
fjord
libra
swims
delve
glade
chaco
annas
eared
putty
yolks
uncut
snort
mauve
hoses
glows
emmet
boric
louse
salsa
twill
rabid
viper
humic
parse
elves
flirt
capes
puree
jerky
lures
leant
axles
swede
tuple
cusps
titre
spiny
whorl
rosin
gurus
fasts
speer
sagas
wryly
conic
tilak
shawn
ovoid
covet
agape
gulch
beaks
hakim
ramps
cairn
roars
manus
degas
orang
solos
lobed
betel
waver
metis
borer
sucks
whiff
droop
geist
razed
gruff
parol
kilos
grimy
smite
auxin
scrip
vagal
blitz
cyber
fudge
hefty
aphid
corso
doers
spars
rumen
fussy
furry
sleet
mamie
crumb
churn
kites
hyoid
lurch
bonny
leary
swaps
lurks
snipe
uteri
quake
plast
pared
bazar
debye
crepe
mammy
tango
scowl
sibyl
spree
vanes
grays
hecht
floss
eject
bayle
coupe
guano
silty
sonne
atoll
labia
irate
imago
riser
duped
lithe
tutti
tonne
rowdy
spect
sheik
dozed
scuba
decoy
chine
pepsi
puffy
sorel
plows
chevy
swoop
psych
stele
husks
quirk
fiefs
vires
pique
combe
jaded
pacts
balmy
nubia
ulama
saver
felon
ennui
missy
gages
fitly
crewe
manes
meson
stupa
fount
pupae
jests
tatar
weeps
lamas
flees
polyp
ammon
mints
kraal
copra
gosse
baggy
droll
foray
clime
buoys
hippo
mises
halts
skiff
thong
torus
troll
samba
xenon
goeth
appel
vouch
quale
brash
silos
fords
nance
terns
rapes
agora
galls
cabal
whist
flops
wench
motte
caput
gruel
foils
timon
sauna
chime
sulky
whoso
peres
brawl
hikes
hinds
eosin
askew
tatty
duels
bunks
sofas
howls
pails
idler
glean
lumpy
nicol
spilt
crass
ravel
gasps
maths
satyr
grits
embed
carpi
oriel
pecan
coney
assez
paled
idyll
colts
inlay
sissy
sepia
shirk
wipes
taxon
tacks
rater
satis
biggs
mazes
flues
wreak
boned
gouty
rajas
dents
radix
retro
mince
fonda
spits
denim
edits
usque
fives
combo
waked
basso
recto
honed
deism
khadi
karst
pekin
furor
nulla
fluke
manse
fetid
perce
knell
feral
mufti
harps
creak
dross
clang
topaz
atria
varna
pilar
pouty
impel
sooty
slats
suave
snarl
tammy
salvo
slyly
bowes
rhino
drape
whoop
stela
lapis
grubs
deuce
soggy
weise
ergot
delos
buffy
foams
unmet
fonds
roomy
dewar
cowed
lasso
bigot
angst
dowel
rheum
polka
booby
sedge
condo
nomen
playa
outre
prong
zulus
calms
ranke
hymen
venal
fosse
rebut
blots
ollie
prise
pawns
smock
baits
pelts
quays
mired
gutta
myrrh
sitka
rungs
ostia
extol
udder
fella
cameo
nudge
lunge
grime
saucy
yucca
sault
mondo
sherd
folia
woken
objet
testa
dusts
biota
ambit
dimes
hyena
gaped
druid
melee
wooed
meath
glans
finis
dawns
ashen
haiku
duomo
benes
sophy
tarot
hells
altho
soapy
molto
oleic
slush
chuse
chats
canny
stubs
swoon
chink
allot
ruble
baser
capri
situs
glens
joker
wisps
feign
dural
lingo
bumpy
monad
varus
begum
toyed
logon
barbs
stoma
cumin
grins
grope
holed
fovea
dirge
tinea
milch
mavis
overs
minos
breve
doeth
amass
mocks
sinew
hovel
coram
dyads
gemma
panda
neath
pithy
deere
nagas
teres
vying
covey
curbs
gouge
coped
fryer
pacha
poesy
antes
solum
dicey
compt
trill
lanky
skips
gnome
awash
licks
rales
deign
amaze
pinks
zoned
lytic
lager
dewan
tomes
soars
kayak
sakti
vesta
grund
afire
hoyle
cacti
dayan
smirk
caron
fille
lazar
boars
bawdy
outdo
riven
trams
sprig
sabin
rooks
cocky
sooth
nitre
belie
moult
sefer
nares
faked
malwa
raine
wicks
medic
whack
seedy
rebbe
copse
plies
yoked
novum
scarp
hater
prank
britt
thane
genii
mowed
nooks
verve
sires
perks
pygmy
dixit
ohmic
racer
nisei
scoff
llama
agers
kiosk
vales
shams
creme
chins
leges
reedy
licht
dally
rakes
prana
hadst
junks
briar
diwan
tarsi
crone
berks
mucin
quint
steen
waken
untie
gilds
undid
cocci
sakai
visor
pansy
rondo
sower
telos
spitz
tesla
chafe
punto
tares
pasty
hauls
howes
sward
dales
dully
lande
glebe
cecum
cleve
dupes
raphe
fumed
midge
drips
weirs
aloes
leeks
loamy
mezzo
swish
sisal
tipsy
demur
bloke
umber
fluff
matin
goers
flume
morph
begat
wince
tummy
rehab
tiara
tilts
cased
swath
octet
feint
deeps
pupal
magus
crump
plasm
creel
trawl
senza
stags
weedy
jeeps
troth
ebbed
joist
scabs
hiked
ileus
graff
groat
unwed
mucho
corns
tabby
larks
utile
wilts
vives
grice
scape
runes
haves
sella
wordy
penna
oaken
drawl
abies
augur
massy
pried
taluk
vertu
shied
chirp
frond
flail
lapel
sopra
murry
simul
hacks
osier
busby
wroth
manas
outta
aglow
hants
cored
toner
basse
caddy
facta
quern
knead
loner
lobar
inane
decry
tenon
rears
mungo
drily
quire
rifts
psoas
talon
suede
devas
lotte
atmos
cress
beret
garbo
stabs
dunno
slaps
tarts
thorp
saheb
begot
levis
peals
prowl
clogs
kondo
aline
dolce
kandy
greys
offal
yogic
gnats
ovule
wrapt
yahoo
quash
longe
gorse
blurs
peels
stews
sushi
perse
ficus
sleds
rabat
maire
ember
pasts
ligne
fishy
specs
blume
crier
chard
hafiz
flier
caked
hutch
mange
serif
salix
jebel
rives
wazir
topos
winks
spurn
seder
avers
urate
roped
parle
biddy
plait
duets
mayas
swabs
fetes
vetch
itchy
devel
comus
euros
toddy
bilge
bogey
cajun
trove
corks
lindy
clods
nevus
yanks
sprue
benet
skein
lutea
junto
abord
mache
mutes
barra
peons
mafic
gonad
boggy
bruit
pipet
skier
albee
thiol
russe
ileal
fixer
nudes
twixt
chola
prods
honan
shins
sepoy
tacky
sated
coder
marls
bream
moron
payor
flips
kinks
indie
caper
altos
skene
clink
octal
pinna
ricks
piggy
warps
coves
padma
floes
hullo
anise
reams
arles
aedes
riper
glyph
gault
pales
tonus
exult
bulla
dyers
kiang
hallo
caved
abler
wails
hails
ruder
lefty
oozed
bossy
roque
marts
gulfs
slags
feare
curio
melba
locum
lopes
jambs
nears
taels
missa
mealy
homey
reals
liken
foals
fecit
pinky
ghats
tetra
laver
pieta
imams
tuner
snags
jeers
evert
aunty
blogs
broil
gavel
pulps
sines
dicky
gayly
gongs
volar
beare
conus
curds
lated
jager
haply
maser
inked
cotes
petre
tines
douce
buffs
cauda
pimps
raved
tabes
corny
marly
cella
allis
fells
carat
pampa
dynes
carer
senna
chace
slunk
grosz
paoli
lodes
snore
fleck
recon
pares
malic
hilum
cavil
crock
ditty
exons
sucre
linga
rayed
cribs
sways
wools
cento
pinot
ryots
sayer
sutta
dulce
stash
flaky
motet
neigh
baste
ameer
teats
croak
warre
stott
agave
fibro
aggie
wands
heare
palpi
ketch
funky
lowed
enrol
plebs
takin
ovals
seeps
afoul
foamy
evict
nutty
jnana
cornu
carbo
halos
manga
canna
miter
occam
aphis
velum
irked
faxes
peony
malar
prawn
chide
wigan
sired
trice
drams
waxen
chiao
nyssa
perdu
geyer
culpa
carex
stria
silts
yorks
tamer
filly
voila
burro
fasti
kalam
phyla
gimme
blobs
gents
amigo
holme
thana
flory
dosed
stomp
cubit
volte
uvula
rivas
meany
crimp
pyrex
caird
velar
tuffs
hilar
tills
dines
taiga
bourg
lauds
yokes
novae
gummy
griff
quare
duras
frets
aloha
deist
mushy
natty
mocha
machi
taffy
posey
rishi
kluge
copes
exude
smoot
loams
crise
bally
claps
lames
paean
sexed
hewed
longa
imbue
twang
blatt
yamen
chums
runic
bandy
glues
furze
nomos
wiper
jaunt
filmy
phial
cutis
voles
borgo
recap
recti
ascot
llano
clack
varia
paseo
prest
kafir
corse
potty
bodhi
swipe
fakes
parka
geste
plats
trist
tapas
vixen
boles
rills
scald
brawn
yogis
tripe
buxom
fundy
bogue
ulema
janes
chyle
acker
alvar
alway
casus
barro
weald
spiky
ingle
moldy
boson
gripe
slurs
mesas
manos
refit
vapid
rerun
aeons
mulla
motes
fiord
faery
lucre
pager
crape
ranee
trios
lotta
primi
allyl
astir
taber
wanes
tsars
garda
teste
tench
goofy
runny
lycee
eland
pylon
humph
shute
saran
zakat
pined
chock
pored
theca
tepee
clary
lovat
batik
slaty
bubba
gules
hulks
viner
meaty
tryst
wispy
umbra
phlox
slays
anent
reiki
khans
gulag
hider
hurls
cates
sulci
burrs
unlit
stank
tempi
jumpy
safes
guava
dalle
spoor
prion
sadhu
barbe
nappe
donny
morro
sixes
kanji
allee
boule
glace
filet
kinky
brome
dorms
lifes
memes
milks
slams
dunce
spook
fakir
izard
furth
azide
sheol
chary
coons
sambo
yerba
spiel
dears
oboes
cinch
bylaw
tragi
claes
laths
minis
krill
paged
jawed
strew
sumac
pushy
rimes
keels
banns
gumbo
blase
wrens
corky
bolls
gusty
trims
trine
pudgy
haram
snobs
jemmy
moire
sprat
freon
wheal
eider
acini
dolor
culex
gayer
pulpy
yawns
thins
testy
surah
jukes
brier
pappy
humps
hansa
kraut
mayst
frill
weems
savin
pokes
chino
duces
cruse
beals
unary
skids
minim
shuns
artis
chemo
flout
ejido
mandi
lofts
fawns
borel
nines
elfin
ghazi
nonce
skits
aland
greve
folie
meane
oculi
halve
lotto
amici
emerg
bogie
henna
kyrie
egret
bruin
soaks
scone
cissy
emirs
hight
bagel
sikes
capon
scamp
apter
swank
reaps
draco
gwine
saris
gaols
incus
sodas
festa
nomic
mudra
pseud
brigs
copal
tains
recta
scull
dinar
dowdy
feted
soled
fouls
diels
lupin
selva
tromp
hiker
carle
strep
pauls
blare
flack
routh
oozes
animi
clift
heald
arete
bouse
moats
kisan
peeps
peaty
saner
gilly
stade
bogle
ronde
voxel
chews
mudge
molal
sarge
aleck
swart
cocos
odeon
gulps
cubed
scree
antic
inbox
doled
twirl
pions
codec
golem
shays
sturt
beady
kutch
snuck
pedis
piney
fluor
mylar
vroom
lamia
lobos
gunny
xenia
barca
ombre
hadji
shand
noirs
coven
frisk
balsa
kells
boche
motus
picot
biker
issei
kames
jacky
brack
leman
howdy
batty
sassy
tress
pitot
teems
edify
nicks
tucks
mimes
apgar
grama
daunt
paves
dinna
grebe
tapir
donut
doyen
knowe
kneed
eclat
soyuz
dropt
pecks
tulle
bongo
golly
gabby
porgy
belch
coops
coyly
idees
pigmy
bated
bifid
rusts
dilly
lethe
betas
drear
gamba
rubus
durum
pesto
gloat
cooed
serai
zaman
trots
lamed
pesky
quips
igloo
lomas
brats
biome
chapt
toots
attar
liana
seely
diazo
hanse
coxae
sayed
sabra
aleph
crony
chimp
dered
caret
cokes
brule
sunna
pubes
filer
tical
dobie
coste
sulfa
bromo
lochs
cheka
repos
bilbo
debar
cleat
dudes
axils
clank
sider
lysed
licit
broch
poser
thang
preys
thema
punks
baize
tweak
taira
zilla
sirup
hoots
crura
dotty
colas
burks
stilt
dirks
fedex
slake
czars
guyot
wolfs
virtu
pawed
ponts
burin
solus
bebop
porno
oiler
hirer
sylva
visto
perky
naves
lares
cower
argot
roams
ranga
emacs
dicks
musky
lemur
craps
lossy
salut
terai
warty
lidar
maund
pitta
baldy
stipe
micky
ocher
shaly
vomer
gesso
knits
lotos
cirri
lowes
recal
scams
chyme
bunce
lulls
tubby
hamza
gulph
mangy
fagin
scudi
blurt
roved
filii
jinks
aquae
beefy
bijou
jolts
raspy
poppa
staph
ozzie
egged
melas
annal
clade
krone
karoo
brits
rance
milos
doles
mambo
ngati
malus
meads
wrack
loran
gluon
scrum
dooms
hocks
faxed
coley
snoop
loons
fader
signa
gowan
retry
spank
dells
areca
dingo
tacos
thein
doest
nazir
veldt
paise
jowar
claro
shoji
sager
birks
sodic
daman
raper
raves
splay
feria
regie
deoxy
plena
aping
goest
veers
guppy
silex
micas
slink
morts
nifty
elope
vizir
taras
auras
cloze
peats
stopt
shere
chota
salop
lutes
safed
boons
salic
bakes
treks
spink
abaft
bairn
voulu
bambi
bardo
sulph
waifs
atony
chere
leery
tanka
negus
dumpy
datos
alkyd
ontic
picky
felts
swale
forza
vireo
sarin
gigas
doted
metes
menge
basho
kulak
ovine
pinon
heros
prude
calla
pardy
boeuf
muons
inure
ducat
swash
biped
parra
vegan
spoof
chara
quoad
huger
adzes
avows
locis
debby
naira
fames
reeks
hurly
wacky
slops
gator
amirs
bluer
tansy
henny
carob
gomer
mesne
amble
snide
ploys
abuts
jingo
jural
vinca
chela
anime
mensa
ragas
deare
riled
basta
ninja
shard
thole
icily
snook
quads
tangy
meres
steno
halfa
rials
litho
cluck
brews
palmy
hocus
ummah
singe
oleum
gored
honky
foule
wombs
jagir
diene
spica
snead
lieve
graal
sebum
fucus
lemme
geoid
ident
fitts
sokol
assai
casco
anker
bergs
pinta
comps
marse
belay
hussy
uveal
ramie
idled
ewers
civet
blurb
welts
gauzy
yogin
appro
gecko
drest
soddy
harks
flits
kalpa
putti
goons
proem
ailed
lyase
joust
pshaw
topoi
nappy
tanga
horas
tabla
kudos
nidus
chars
rodes
shura
spunk
ender
telly
ebook
pixie
stylo
fiche
byway
jakes
sural
bents
schwa
agama
therm
muggy
boded
jiffy
dinge
archi
vibes
payed
teeny
bogan
ruses
tilth
shims
baled
ninon
corby
jocks
profs
sicht
comfy
duple
moyle
bassi
macaw
tache
bleat
foist
liven
jibes
amrit
newts
loony
gaddi
hevea
tulsi
forel
fatwa
aider
qualm
catty
strum
crees
apses
latte
harpy
voile
gumma
prate
eyrie
drool
soler
ribes
boyar
spier
seamy
ogres
stour
swill
tanna
throe
grece
koala
mesic
touts
jowls
tenia
damme
synch
upped
boors
manta
hatha
gilts
foyle
piezo
opine
bwana
asura
mitts
gibes
booed
grana
bloat
valse
briny
brims
grads
stets
hanky
whirr
hiver
kivas
paten
taube
aimer
chica
tinct
scapa
elute
woful
hylas
hones
thaws
buret
bract
shuck
cyclo
whelp
varas
carbs
mends
stoat
oxbow
aurum
lolly
tondo
thuja
nanna
damps
pacer
bason
oakum
newel
gandy
sorta
arcus
blebs
bajra
ascus
egger
stope
golds
myoma
erick
befit
clave
kranz
dryas
brava
gooey
finca
blimp
papas
ictal
xylol
tinny
haver
doggy
wicca
musca
merks
swamy
loped
bourn
latus
lairs
rinds
vaunt
hunks
viols
fugal
lanai
scoot
wedel
harts
marae
alack
kohen
pongo
dites
menes
mizen
talma
outgo
ratty
hilus
colls
kylie
loris
panty
splat
heeds
kauri
nitty
dacha
voces
hippy
spats
dhoti
sneed
leafs
parly
zazen
ganja
muley
klang
rummy
heres
moped
recit
rends
asana
corms
hooch
campi
azote
beery
vakil
minty
poled
redon
verry
kilts
expos
hythe
poach
bodes
squib
calve
morne
bocca
bever
stich
sizer
boobs
pomps
compo
mucor
nulls
gaits
serre
pleat
dowie
venae
ghoul
bosun
chewy
akita
farad
nahal
ukase
clews
teary
iodin
scena
cutch
setts
mires
kiley
cedes
plage
fayre
rower
prows
hamed
haled
zooms
arcos
promo
soldi
yager
douse
finny
rioja
duroc
caulk
frons
heist
simba
whats
tames
bided
churl
taxus
meses
sanga
balks
selah
dinky
eniac
cesse
tenno
emmer
ricin
hilts
sensa
borde
druse
hijra
repro
redan
toman
osmic
dulls
mamas
rente
bulks
hajji
gnaws
kapok
fifes
rumba
kerns
soman
wolds
poods
fauns
nisus
eidos
obeah
beeps
redux
ronin
kasha
adios
limed
wadis
witan
reify
platy
sedum
eking
evens
appui
telic
nates
klett
roshi
cuddy
eying
farts
rants
hypha
synth
camas
ludic
ratan
purty
culms
fundi
envoi
wends
luger
lento
jutes
caned
tilde
penne
abase
heigh
boney
numen
liman
auric
blain
gawky
bowne
sunup
bimbo
neves
brane
reges
veena
washy
shite
conto
typos
cecal
odder
smits
routs
jazzy
bunds
comas
gamer
hards
opals
koine
sylph
antar
rangi
ruffs
goold
homed
beaty
mikes
ambos
logie
ering
tanti
murti
lapin
demes
legit
mense
feist
tunny
oared
yummy
drays
detox
naiad
abeam
atopy
resto
prosy
galea
ephod
abaca
genom
orris
jeffs
taxol
moste
ceiba
skied
snips
zante
arhat
rearm
indol
beton
basti
goads
culty
loach
salto
forbs
frits
kopje
senti
karat
mages
pipit
rubel
caeca
saman
braes
malam
coots
arish
crome
bitte
darks
aliya
coxal
snark
skeet
agger
ouija
antis
torii
wafts
bares
brags
hause
ameba
cubby
sates
preen
tenue
putts
aspic
riffs
stumm
rueda
pombe
pates
milpa
fagot
vivas
shaul
ahold
botts
plica
jomon
podge
palps
linac
elate
maron
zorro
mauri
coble
louts
laves
cabby
shans
brede
giron
infix
hewer
doges
wanly
sitar
sapor
layed
squab
cooch
buffa
duvet
rasta
vulgo
murex
tided
spick
seres
cobbs
kiddo
manto
skims
maces
tokay
swags
novas
jalap
rares
ninny
talar
vacua
maggs
fiver
tumid
kudzu
amuck
rinks
wooly
hance
asper
vanda
lysol
stull
toile
darky
hyped
worts
nebel
segni
segue
dildo
snaky
forex
roods
palla
gutsy
rangy
dryad
musts
manis
croon
pedes
dancy
deify
garni
pimas
medii
adown
ology
thrum
shush
laker
mimed
sepal
rands
leese
palay
sures
doody
ancon
emend
amain
rebar
palls
angas
tings
sours
unica
techs
cajon
baboo
daffy
sputa
minks
sedes
kugel
frate
tunas
enure
treed
batts
muffs
dopey
jello
gular
lepra
picas
rived
octyl
verra
leggy
gazer
chump
waddy
decal
junco
gaged
frist
thuds
mosso
dozer
jades
mamba
flunk
banes
porky
rayne
limps
amiga
lovey
kloof
scrim
hijab
linum
paned
bezel
oxime
marah
esker
damns
stane
bling
zloty
mongo
wahoo
boner
hazan
yelps
prost
pened
gores
qubit
bento
esses
nones
arret
culls
dhows
geeks
uncus
recce
carse
foots
cully
wooer
lathi
plebe
uhuru
unfed
lyres
zines
flava
futon
spall
slane
lores
joram
clast
sechs
sappy
peece
benne
selle
lardy
pokey
navvy
wormy
quaff
amido
locos
tiros
salat
vespa
youse
toque
cutty
matza
aways
phare
drome
chowk
proms
tarns
grise
bitty
ranis
penes
skulk
kinin
