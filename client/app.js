App = {
    contracts: {},
    init: async ()=>{
        console.log("loaded")
        await App.loadEthereum()
        await App.loadAccount()
        App.render()
        await App.loadContracts()
    },
    loadEthereum: async ()=>{
        if (window.ethereum){
            console.log('Ethereum exist')
            App.web3Provider = window.ethereum
            await window.ethereum.request({method: 'eth_requestAccounts'})
        } else if(window.web3){
            web3 = new Web3(window.web3.currentProvider)
        }
        else{
            console.log('No Ethereum browser is installed. Try it installing Metmask')
        }
    },

    loadAccount: async () =>{
        const accounts = await window.ethereum.request({method: 'eth_requestAccounts'})
        App.account = accounts[0]
    },

    loadContracts: async ()=>{
        const res = await fetch("TasksContract.json")
        const tasksContractJSON = await res.json()

        App.contracts.tasksContract = TruffleContract(tasksContractJSON)

        App.contracts.tasksContract.setProvider(App.web3Provider)

        App.tasksContract = await App.contracts.tasksContract.deployed()
    },

    render: () => {
        document.getElementById("account").innerText = App.account
    },

    renderTasks: () => {
        const taskCounter = await App.tasksContract.tasksCounter()
        const taskCounterNumber = taskCounter.toNumber()

        for (let i=1; i <= taskCounterNumber; i++){
            const task = await App.tasksContract.tasks(i)

            const taskId = task[0]
            const taskTitle = task[1]
            const taskDescription = task[2]
            const taskDone = task[3]
            const taskCreated = task[4]

            let taskElement = `
                <div class="card bg-dark rounded-0 mb-2">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span>${taskTitle}</span>
                        <div class="form-check form-switch">
                            <input class="form-check-input" data-id=${taskId} type="checkbox"
                            ${taskDone && "checked"} onchange="App.toggleDone(this)"/>
                        </div>
                    </div>
                    <div class="card-body">
                        <span>${taskDescription}</span>
                        <p class="text-muted">Task was created ${new Date(taskCreated*1000).toLocaleString()}</p>
                    </div>
                </div>
            `

            html += taskElement;
        }

        document.querySelector("#tasksList.innerHtml") = html
    },

    createTask: async (title, description)=>{
        const result = await App.tasksContract.createTask(title, description, {
            from: App.account
        })
        console.log(result.logs[0].args)
    },

    toggleDone: (element) =>{
        const taskId = element.dataset.taskId
        await App.tasksContract.toggleDone(taskId, {
            from: App.account
        })

        window.location.reload()
    }

}