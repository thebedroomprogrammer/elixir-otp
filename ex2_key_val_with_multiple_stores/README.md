# Part 2. Managing multiple stores using GenServer processes — Elixir/OTP
![](https://miro.medium.com/max/4896/1*rN-RzouMEhwJWIUex2JZ6w.jpeg)

Hey, have you stumbled upon this post directly without reading the previous article because you searched for something and Google decided to teleport you here? Well, then I would suggest you read the previous article which is the first part of the 7 part series that I am writing.

Now, if you have read the previous article then let’s begin directly with this article.

So previously we created a server process that stores some values in a key-value store. Now what we will aim for is to create a server process with a Manager process which will help us manage multiple key-value stores.

With the introduction of a manager process, we will be able to create multiple stores and store key-values in them separately because guess what, we are not learning Elixir to just to deal with a single process.


## Let’s get started 🏎️

Before beginning make sure you have Elixir and Mix installed in your system.


Now create a mix project by typing

```
mix new ex2_key_val_with_multiple_stores
```

This command should create your project structure like this

![](https://miro.medium.com/max/514/1*oanz6RnWOOkLXB2aur-DKg.png)

Delete all the files in the lib folder and create a file with name **manager.ex** and **store.ex**. Also copy the previously created **server.ex** in the same folder.

The reason why we are creating these many modules is that it is always good to decouple your code in the form of modules and functions wherever possible. It makes testing a lot easier and makes parts of your app to plug and play anywhere you want.

With the introduction of a manager process to manager multiple instances of stores we are looking to achieve an architecture like in the image below.

![](https://miro.medium.com/max/711/1*XAwz0s7AMcKRO8TrzQntXg.png)

* **init/1** accepts one argument. This is the second argument provided to **GenServer.start/2**, and you can use it to pass data to the server process while starting it.
* The result of **init/1** must be in the format **{:ok, initial_state}**.
* **handle_cast/2** accepts the request and the state and should return the result in the format **{:noreply, new_state}**.
* **handle_call/3** takes the request, the caller information, and the state. It should return the result in the format **{:reply, response, new_state}**.

## Show me some code 👨‍💻

Here we now have 3 entities to care about.
1. Manager
2. Server
3. Store

![](https://miro.medium.com/max/1290/1*_vwuexUHUTT8798j1BHxIA.png)

The Manager process is a GenServer whose task would be to create a store as a server process and maintain a map of stores created with their name and PID which the client would use to communicate.

In the Manager file we startup a GenServer and this time we pass an extra parameter of name: __MODULE__ to it. This registers the GenServer’s name as it’s module name so we won’t be needing a PID to communicate to it. Since we are going to create only one Manager there would only be one Manager with that name.

The internal state of our Manager will store all the store related information in the form of Map with keys being the name of the store and values being their respective PIDs.

Whenever a command to create a store is issued to the Manager it first checks if the store with the same name is already present in its state or not. If yes then it simply returns the PID else it starts up a new server process and stores the name and PID of that server process in its an internal state and then returns the PID of the newly created server process.

![](https://miro.medium.com/max/1158/1*8TAaOBcbCoE6sXDAlaW7tA.png)

The Server is the simple GenServer that handle the task to manipulate the store values when the client issues a specific operation to it to perform.
The server code is the** **same as before. It handles all the operations like **put**, **get** and del but in a more abstracted way with the help of a Store module.

![](https://miro.medium.com/max/822/1*efePbTB4Nnq5ijAA7gb6uw.png)

To promote code reuse we took out the Store operations in a different module called KeyVal.Store. This makes the app simple.


## The final run 📟

In order to start the whole system, we first initiate an elixir session
by typing

```
iex -S mix
```


![](https://miro.medium.com/max/2048/1*57xmO6qYbAXAykmk1aeQIA.png)

Now we start the Manager process with the startup command. After starting the manager process we create two stores with different names and store their PIDs in local variables.

Then we communicate to the servers with their respective PIDs to store, retrieve or delete values in the store. Since both the server processes are different the values stored in them are completely different. You won’t be able to query for a value stored in Server 1 using the PID od Server 2 since they do not share the stores.

So this is how you can Manager multiple stores using GenServers.

I hope this post has helped you get a little bit better understanding of the whole process.

The complete source code of all the parts are [here](https://github.com/thebedroomprogrammer/elixir-otp).

## References 📝

1. [Elixir in Action. 2nd Edition.](https://www.manning.com/books/elixir-in-action-second-edition)
2. [GenServer behaviour docs.](https://hexdocs.pm/elixir/GenServer.html****)

