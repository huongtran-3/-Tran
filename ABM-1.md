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

# Creating sheeps and wolves
for i in range(num_of_agents):
    agents.append(agentframework_v2.Agent(environment, agents, neighbourhood))
    
for i in range(num_of_wolves):
    wolves.append(agentframework_v2.Wolf(agents, scope))   
    
    
# Moving, eating and sharing of agents
The code below will define the sheep to move, eat and share to other sheep. 
The sheep will move around the environment and their speed will depend on the amount of food they had eat.
The sheep will eat 10 units of food in their position, incase the food in their current position is less than 10, they will eat whatever is left there.


# Moving and hunting of Wolves


Wolves share the move function with the sheep with the difference that their behaviour does not depend on food; instead they can only move 2 units per iteration. They also have a unique function called hunt with which they are able to delete agents from the environment if they are within their scope.

hinh

Below you can see a snapshot of the model. Wolves are represented by black circles and sheep by yellow stars.

![abm-pic](https://user-images.githubusercontent.com/55794712/68553534-2b47ad80-041a-11ea-9797-38715c957ce9.png)

