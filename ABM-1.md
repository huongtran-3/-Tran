## Agent Based Model

The model is a simple Agent Based Model (ABM), which includes two different types of agents: sheep and wolves. 

The sheeps will wander in the created environment searching for food. Sheeps have two main fuctions: *eating* food and *sharing* it with other sheep (other_agents).
The wolves have two main fuctions: *moving* and *hunting* sheep in the created environment.

# The agent:
num_of_agents = 50
num_of_wolves = 60
num_of_iterations = 100
neighbourhood = 20
scope = 10


The number of iterations for each agent is the times of the agent's move, eat, share and hunt.
The neighourhood is the distance between agents to share food
The scope parameter defines the hunting distance for each wolf.



Eating and sharing resources are important behaviours for our sheep. This will allow them to store food —and thus be harder to hunt— as well as colaborate with other colleagues by equally dividing the sum of both of their food. Sheep will eat 10 units of food provided that there are more than 10 units of food in the position where they are “standing”; otherwise they will eat whatever is left in their current position.

hinh

Wolves share the move function with the sheep with the difference that their behaviour does not depend on food; instead they can only move 2 units per iteration. They also have a unique function called hunt with which they are able to delete agents from the environment if they are within their scope.

hinh

Below you can see a snapshot of the model. Wolves are represented by black circles and sheep by yellow stars.


