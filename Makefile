//hashContract = TaskContract.address
tasksContract = await TaskContract.deployed()
counter = await tasksContract.taskCounter()
counter.toNumber()
tasksContract.createTask("mi primer tarea", "que hacer")
task = await tasksContract.tasks(0)


migrate:
	@truffle migrate

run:
	@