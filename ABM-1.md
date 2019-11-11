# Agent Based Model

The model is a simple Agent Based Model (ABM), which includes two different types of agents: sheep and wolves. 

The sheeps will wander in the created environment searching for food. Sheeps have three fuctions:*moving* to searching for food, *eating* food and *sharing* with other sheep (other_agents).
The wolves have two main fuctions: *moving* and *hunting* sheep in the created environment.

## The agent:
num_of_agents = 50
num_of_wolves = 60
num_of_iterations = 100
neighbourhood = 20
scope = 10


The number of iterations for each agent is the times of the agent's move, eat, share and hunt.
The neighourhood is the distance between agents to share food
The scope parameter defines the hunting distance for each wolf.

## Creating sheeps and wolves
for i in range(num_of_agents):
    agents.append(agentframework_v2.Agent(environment, agents, neighbourhood))
    
for i in range(num_of_wolves):
    wolves.append(agentframework_v2.Wolf(agents, scope))   
    
    
## Moving, eating and sharing of agents
The code below will define the sheep to move, eat and share to other sheep. 
The sheep will move around the environment and their speed will depend on the amount of food they had eat.
The sheep will eat 10 units of food in their position, incase the food in their current position is less than 10, they will eat whatever is left there.

#Randomly moving      
    def move(self):
        if random.random() < 0.5:
            self.y = (self.y + 1) % 300 
        else:
            self.y = (self.y - 1 ) % 300
            
        if random.random() < 0.5:
            self.x = (self.x + 1 ) % 300
        else:
            self.x = (self.x - 1 ) % 300
            
#Eating in the environment
    def eat(self): 
        if self.environment[self.y][self.x] > 10:
            self.environment[self.y][self.x] -= 10
            self.store += 10
        else: 
            self.environment[self.y][self.x] < 10
            self.store += self.environment[self.y][self.x]
            self.environment[self.y][self.x] -= self.environment[self.y][self.x]
            
    def share_with_neighbours(self, neighbourhood):
        for i in self.agents_list: 
            if i != self: 
                distance = self.distance_between(i) 
                if distance <= neighbourhood: 
                    ave = (self.store + i.store)/2 
                    self.store = ave
                    i.store = ave

## Moving and hunting of Wolves
The wolves have the same move's function with agents, however, their moving does not be limmited by food.
The hunting's function allows to eliminate the sheep in the environment. 
The model also includes stopping conditions when all the sheep have been hunted by wolves within the environment.

#Function that hunts (eliminate) sheeps              
    def hunt(self, agents_list):
        for i in agents_list:
            distance = self.distance_between(i) 
            if distance <= self.scope:
               agents_list.remove(i)

## The environment:
The data is saved as ‘data.txt'. The environtment is the data where the agents can move, eat and share with their neighbour.

The snapshot of the model can find below. Wolves are represented by black circles and sheep by yellow stars.

![abm-pic](https://user-images.githubusercontent.com/55794712/68553534-2b47ad80-041a-11ea-9797-38715c957ce9.png)

# The code
The final code can be accessed [here](ABM-Assignment-1).  


Thank you for your reading.
