# Town Game

## Objective
Reach the status of a country (40,000) without succumbing to societal imbalances and random events.


## Game design loop
The player can use their money to purchase resources. After the player is done spending however much money
they want, they will progress the game by a turn. Progressing by a turn will prompt a random event, which 
may be good or bad or neutral. The event will impact the resources by adding or removing from them. Progressing
the turn will also increase the amount of days the player has been living, which will be used as a scaler for
the severity of events. The game is lost when the player's population reaches 0, or the control level of the town
reaches zero.

## Terms
 - Money: The main currency used to buy additional resources
 - People: The population of the town
 - Red People: The population of additional people who are homeless, criminals, or otherwise lawless
 - Houses: The homes in the town. Each home can house 4 people.
 - Workplace: The places to work in the town. Each workplace can employ up to 10 people.
 - Control: The strength to inspire and enforce order over a population. The game is lost if this reaches 0.

## Mechanics
At the end of a turn, the town will do some amount of work before the prompted event. Mainly this is a function
of how the people spend their time. The outcome of the town is determined *before* the prompted random event is
played out. This way the player has some level of control over preparing for the next event.

### Population 
The population is made up of normal citizens and red people. Red people represent the segment of the population
that are homeless, criminals, or otherwise lawless. Every turn each person has a 1% chance of death, where they
will die from assumed old age or natural causes. Otherwise, depending on if they're red or not and the resources
of the town, they will do some amount of work.

### Reproduction vs. Working
Each person by default will have a 6% chance to have a baby (simulating the fact that 2 people are needed to
make a baby). This is reduced to 3% if the person has to work. A person will opt to work by default if there 
is space for them to work. People who work will generate money for the player to use next turn. People who 
do not work will do nothing.


*(refer to the appendix for the reasoning for this probability calculation)*


### Red People
Red people will sap the town's control by some amount each turn if above a threshold of 5% of the normal people
population. If the control of the town reaches 0 the game is over. The town's 'control will regenerate if 
red people make up less than 5% of the normal people population. Normal people will become red people if there
are not enough houses at the end of turn to house everyone. The difference in unhoused people is the amount of
people who will turn red *next* turn (they don't have an effect the turn they turn red). Even if the amount of
homes can house red people, they will only have a 60% chance to reform by themselves. They can manually be 
reformed by spending money, but if they are reformed while you do not have enough houses, they still experience 
the normal odds of turning red due to overpopulation.

### Control
A town's control is a measure of how powerful of a rule you have over your population. There is no upper limit
to reflect that you may be very authoritrian and invested in control, which can allow you to tolerate higher
levels of red people. Control may be impacted by events.

### Spending Money
Money can be spent/impacted in the following ways during a turn:
- Buy people to move in to the population
- Buy/sell houses to change the amount of houses
- Buy/sell workplaces to change the amount of workplaces
- Reform red people to reduce the amount of red people
- Assert control to increase the town's control levels
*notice that there isn't a way to manually get rid of population*

The amount that houses, workplaces, asserting control, and reforms cost/sell for will scale with the amount of 
days that have passed. Generally the player will want to leave some money in the bank just in case.


### End of the turn
The turn ends when the player taps end turn. The current resources at the end of the turn are used to determine
how much other resources will increase or decrease. They will be determined in the following order:

1. 1% of normal and red people will die from old age or natural causes.
2. Normal population will work or have children. If they work, they will generate money scaled by the 
population and day counter.
3. Red people will sap the control if able, or if not then the control will naturally regenerate by some amount.
4. Red people will also check if they can reform themselves based on the available housing (60% chance)
5. Based on current housing and new normal population numbers, some amount of the population will defect to 
being red people.
6. Turn ends, player is notified of changes, and event starts.

### Events
This will occur at the end of the turn after the player has spent their money. Some random event will happen 
that will test the player's resources, either doing an actual check and determining an outcome, randomly having
an outcome, or always having a predetermined outcome. These events need to scale based on the day. The events
also need to vary between being good, bad, both, or neutral/having no effect.


# APPENDIX

This is a section dedicated to keeping notes about how certain ideas or numbers were derived for future reference.

## Population Growth

To model a more realistic population growth where each couple has 2-3 children on average over their lifetime, 
I need to adjust the annual probability of childbirth.

Let's assume the following: Couples have children within a certain age range, typically from age 20 to 40, giving a 20-year 
span for childbirth. I want to aim for an average of 2.5 children per couple.

Here’s how I calculated the annual probability pp:

    Determine the total number of years in which a couple can have children:
    Total years=20
    Total years=20

    Set the average number of children per couple:
    Average children=2.5
    Average children=2.5

    Calculate the annual probability of childbirth for a couple:

    To find the probability pp that results in an average of 2.5 children over 20 years, we can use the formula for the expected number of births in a binomial distribution:
    Expected number of births=Number of years×p=2.5
    Expected number of births=Number of years×p=2.5

    Solving for pp:
    p=2.520=0.125
    p=202.5​=0.125

Thus, each couple should have a 12.5% chance of having a child each year to achieve an average of 2.5 children per couple over 
a 20-year period. This is a more realistic probability for modeling a stable population growth rate. However because this game
does not yet model populations based on simulating individual people, rather just broad assumptions of the population as a whole,
I need to find a better probability that assumes the following to avoid a runaway population:

- Each person can have children indefinitely outside of any age requirements
- Each person doesn't explicitly die of old age (but rather other causes during the game), earlier I actually assumed arbitrarily
 that everyone by default will have a 1% of dying in a given year.
 
 We can use a Poisson distribution to model the number of children each person has over their lifetime, where the average 
 number of events (having children) is a product of the rate (probability) and time.
 
 For a Poisson distribution with average λλ, where λλ is the average number of children desired, the probability pp 
 per year can be approximated if we want an average of 2.5 children:

    Given that the Poisson distribution has a mean λλ, set:
    λ=2.5
    λ=2.5

    If tt is the number of years (which is indefinite), we treat pp as a very small annual rate such that λ=p×tλ=p×t.

    Given an indefinite period, we need a small pp that, over a practical average human reproductive span 
    (say 20 years, even though the period is indefinite, we use a realistic span for the sake of this calculation):

    Set the average reproductive span:
    Reproductive span=20 years
    Reproductive span=20 years

    To keep the calculation realistic over the span, we can use:
    p×20=2.5
    p×20=2.5

    Solving for pp:
    p=2.520=0.125
    p=202.5​=0.125

However, if we assume an indefinite lifespan and the possibility of continual childbearing each year, we reduce pp further:

    To make the probability very small considering indefinite childbearing:
    Adjusting for Indefinite Lifespan:

    Considering an extended span:
    If we double the span to 40 years for the sake of having a conservative estimate:
    p=2.540=0.0625
    p=402.5​=0.0625

    Therefore, a reasonable annual probability pp for an individual who can have children indefinitely would be approximately:
    p≈0.06 or 6%

Using a 6% annual probability of having a child for each person would be a reasonable estimate to model a population 
where individuals could potentially have children indefinitely and still achieve an average of 2-3 children over their 
lifetime. This helps mitigate the issue of overly rapid population growth. And then to simplify the calculation we can assume
that people are half as likely to have children if they had to work in a given year, so 3%.
