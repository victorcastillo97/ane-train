const TasksContract = artifacts.require("TasksContract")

contract ("TasksContract", ()=>{

    before(async ()=>{
        this.tasksContract = await TasksContract.deployed()
    })

    it('migrate deployed successful', async () =>{
        const address = this.tasksContract.address
        assert.notEqual(addres, null);
        assert.notEqual(addres, undefined);
        assert.notEqual(addres, 0x0);
        assert.notEqual(addres, "");
    })

    it('get Tasks list', async () => {
        const tasksCounter  = await this.tasksContract.taskCounter();
        const task = await this.tasksContract.tasks(tasksCounter);

        assert.equal(task.id.toNumber(), tasksCounter);
        assert.equal(task.title, "mi primer tarea de ejemplo");
        assert.equal(task.description, "tengo que hacer la tarea");
        assert.equal(task.done, false);
        assert.equal(tasksCounter, 1);
    })

    it ('task created successfully', async ()=>{
        const result = await this.tasksContract.createTask("some title", "description two");
        const taskEvent = result.logs[0].args;
        const tasksCounter = await this.tasksContract.tasksCounter();

        assert.equal(tasksCounter, 2);
        assert.equal(taskEvent.id.toNumber(), 2);
        assert.equal(taskEvent.title, "some title");
        assert.equal(taskEvent.description, "description two");
        assert.equal(taskEvent.done, false);
    })

    it ('task toggle done', async ()=>{
        const result = this.tasksContract.toggleDone(1);
        const taskEvent = result.logs[0].args;
        const task = await this.tasksContract.tasks(1);

        assert.equal(task.done, true);
        assert.equal(taskEvent.done, true);
    })

})