## Agent Based Model

*Hungry like the Wolf*

The model has the purpose of creating two different types of agents: sheep and wolves. Once created, sheep will wander through an environment containing resources or “food”. In addition, they have two more functions: eating and sharing units with other sheep when they come close to a certain —and predefined— distance.

The wolves, on the other hand, have the capacity of moving through the environment and hunting sheep when they step into a certain distance from them. The sheep’s moving function allows them to increase their speed the more food they eat, allowing them to escape from their predators. The model stops when all the sheep have been hunted by the wolves.

Let’s take a closer look into the code. First, some parameters are defined. Here you can define the number of sheep —coded as agents— and wolves you want in the model. You can also specify the number of iterations for each agent, i.e. how many times they will move, eat, share and hunt (this has not been divided for each type of agent). Finally, the neighourhood parameter specifies the distance a sheep needs to be from another in order to share resources, whilst the scope parameter defines the hunting distance for each wolf.

hinh

As mentioned before, sheep will move around the environment and their speed will depend on how much food they have stored. In this example, they move 1 unit plus the 0.5% of what they have eaten so far. We don’t want them to be extremely fast! However, this could be changed if needed.

hinh

Eating and sharing resources are important behaviours for our sheep. This will allow them to store food —and thus be harder to hunt— as well as colaborate with other colleagues by equally dividing the sum of both of their food. Sheep will eat 10 units of food provided that there are more than 10 units of food in the position where they are “standing”; otherwise they will eat whatever is left in their current position.

hinh

Wolves share the move function with the sheep with the difference that their behaviour does not depend on food; instead they can only move 2 units per iteration. They also have a unique function called hunt with which they are able to delete agents from the environment if they are within their scope.

hinh

Below you can see a snapshot of the model. Wolves are represented by dark circles and sheep by yellow stars.

hinh

The code can be accessed through my repository by clicking here. Just note the quantitity of sheep and wolves you use, if there are way more sheep than wolves the model can take a while to stop and in that case you might want to get yourself a cuppa and enjoy the animation (you can always just close the pop-up window).
