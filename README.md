Ruby on Highway
==

A vanilla Ruby project inspired by Ruby on Rails to demonstrate understanding of Ruby, middleware, and Rails

## Usage
Clone the repo
```
ruby lib/run.rb
```

## A List of features & functionalities
### All features are implemented using only vanilla Ruby
1. Runs Rack server
2. Renders templates with ERB (Embedded Ruby)
3. Stores sessions in cookies and HTTP header
4. Stores temporary response in Flash
5. Routes URLs and invokes actions with Regex
6. Handles exceptions and renders full stack trace
7. Serves static assets from public folder

## Test Routes
Root
<br>
[localhost:3000](http://localhost:3000/)

Index
```
/
/dogs         
```

Create a new dog
```
/dogs/new
```

Exceptions
```
/raise
/nil
```
