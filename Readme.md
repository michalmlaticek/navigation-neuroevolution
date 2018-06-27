*****************************************************
This is a quick user guide on how to use simulator
*****************************************************

***********
Folders
***********
src/ - is the folder that holds the actual code, but it can be considered as a library so there should be no need to change anyting in there
lib/ - contains the functions of the GA algorithm
maps/ - contains map images that were used during simulation
test/ - contains some unite and performance tests
experiments/ - contains the actual experimnt set-up
logs/ - contains the output after the experiments are run. But that is as per my usage. User actually controlls this part withi his/her own configuration, so it can be stored anywhere



****************
Intended usage
****************
I would suggest to review the project inside experiments/_demo folder.

runEvolution:
Is the experiment initialization script. It instantiates all the required objects and then calls the GA.


continueEvolution:
This script is intended for when you want to calculate additional generation for some reason.

MutableObject:
The majority of the decisions is made within callback implementation. The intended use of MutableObject
is to provide ability to store additional data that is not part of the  'standard state' object.

callback:
As already mentioned, the intended use is to give the user as much flexibility as possible. The logic is
is therefore executed by callbcks that need to be implemented by user. The demo provides simple examples.
Through out the simulation following callbacks are invoked:
    initNetsCb - callback for initializing networks. This cb is invoked when a new generation simulation starts. 
                The runSimulation uses directly the provided initNets method. The imprtant part is, 
                that the method is only invoked with the pop argument during simulation, so the net layout
                needs to be instantiated during experiment initialization phase.
    newPopCb - callback for generating new population. 
                !!! IMPORTANT: Needs to return a matrix with 
                (chromosome length, population size) dimensions.
    controllerCb - this method is intended to be the neurocontroller. It is invoked after 
                'enviroment scanning/sensor reading'. 
                !!! IMPORTANT: It needs to return the rotation ange and speed.
                Based on those the new position will be calculated. The method is invoked with agruments
                nets (output of initNetsCb) and current simulatin state (step_state).
    stepEndCb - this callback is invoked after the step ends, that means new position and rotation was calculated.
                It's invoked with step_state argument.
    pathEndCb - this callback is invoked after simulation for one paths end. It's invoked with path_state argument.
    mapEndCb - this callback is invoked after simulaton for one map ends. It's invoked with map_state argument.
    simEndCb - this callback is invoked after simulation end for the generation. (all maps / paths) 
               It's invoked with sim_state argument.
                !!! IMPORTANT: this callback needs to return a fintess vector (1, population size)
    drawCb - if provided/enable - this callback is invoked prior to simulation end and should visualize the
             the current state.


******************
* States
******************
Desccription of different state object provided as callback arguments.

step_state:
	nets 				% output of initNetsCb
	map 				% map structure - output of mapFromImg(..) function
	start				% start point (1, 1, 2)
	target				% target point (1, 1, 2)
	r 	% as robot		% struct representing the robot. See initSettings function.
	angles 				% current global angle for each chromosome/robot (1, population_size)
    positions			% current global position for each chromosome/robot (1, population_size, 2)
	bodies				% (x, y) representation of each robots body (? - depends on the radius, population_size, 2)
	sensor_lines		% (x, y) representaton of each robots sensors (? - depends on sensor count and length, population_size, 2)
	angle_errors		% azimuth in reference to target point (1, population_size)
	target_distances	% each robots distance to target (1, population_size)
	collisions			% collision count untill this step
	collision_idx		% indication of collision in the curret step
	readings			% represents the sensor readings (sensor_count, population_size)
	
	
path_state:
	is actually the last step step_state
	
map_state:
	paths - is a list / cell containing path_states
	
sim_state:
	maps - is a list containing map_states
	
	
*****************
* Metric
*****************
Within experiment folder, there is a function called metric.This function should provide base reporting / charts if naming convention of the saved output objects was followed.
See method descritpion for more information.



*****************
* Simulate / visualize
*****************
Within experiment folder there is a simulate function.
This method is here to run a simulation for a desired (sub)population. See method description for more information.


NOTE: Within the log folders, the experiments have their own simulateThis function. The simulate function mentioned above tries to be generic, 
but to be sure, we're also including this dedicated simulation method. The usage is the same.