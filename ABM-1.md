# Agent Based Model


The model is a simple Agent Based Model (ABM), which includes two different types of agents: sheeps and wolves. 

The sheeps (agents) are moving in the environment in order to searching for food. Sheeps have three fuctions:*moving*, *eating* and *sharing* with other sheeps (other_agents).
The wolves have two main fuctions: *moving* and *hunting* sheeps in the environment.

* The number of sheep (agents) are 50
* The number of wolves are 60
* The number of iterations for each agent is 100, is the times of the agent's move, eat, share and hunt.
* The neighourhood is 20 which is the distance between agents to share food
* The zone is 10, is the distance of hunting for each wolf.  
    
    
### Moving, eating and sharing of sheeps (agents)
The code will define the sheep to move, eat and share to other sheep. 
The sheep will move around the environment and their speed will depend on the amount of food they had eat.
    

### Moving and hunting of Wolves
The wolves have the same move's function as well,and their moving does not be limmited by food.
The hunting's function allows to eliminate the sheep in the environment. 
The model also includes stopping conditions when all the sheep have been hunted by wolves within the environment.

### The environment:
The data is saved as ‘data.txt'. The environtment is the data where the agents can move, eat and share with their neighbour.

The snapshot of the model can find below. Sheeps are denoted by yellow stars, wolves by black circles.

![abm-pic](https://user-images.githubusercontent.com/55794712/68553534-2b47ad80-041a-11ea-9797-38715c957ce9.png)

# The code
The final code agentframework and model can be accessed [ABM-Assignment-1](https://github.com/huongtran-3/ABM-Assignment-1).  



*Thank you for your reading!*

![Lambs-700px](https://user-images.githubusercontent.com/55794712/68634251-b72a0a00-04ec-11ea-9118-2ef8ed8889fc.jpg)

