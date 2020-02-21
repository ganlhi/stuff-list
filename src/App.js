import React, { useState } from 'react';
import './App.css';
import { BrowserRouter as Router, Route, Redirect, Switch, useLocation } from 'react-router-dom';
import Sidebar from './Sidebar';
import List from './List';
import Create from './Create';

function App() {
  const [stuffs, setStuffs] = useState([
    {id: 1, name: 'test stuff', favorite: false}
  ]);

  const createId = () => {
    const existingIds = stuffs.map(s => s.id);
    return existingIds.length > 0 ? Math.max(...existingIds) + 1 : 0;
  }

  const addStuff = (name) => {
    const stuff = {
      id: createId(),
      name,
      favorite: false,
    };

    setStuffs([...stuffs, stuff]);
  }

  const deleteStuff = (id) => {
    setStuffs(stuffs.filter(s => s.id !== id));
  }

  const setFavorite = (id, favorite) => {
    setStuffs(
      stuffs.map(s => 
          s.id === id
            ? {...s, favorite}
            : s
        )
    )
  }

  const nbFavorites = stuffs.filter(s => s.favorite).length;

  return (
    <Router>
      <Sidebar nbFavorites={nbFavorites}/>
      <section>
        <Switch>
          <Route exact path="/">
            <Redirect to="/list/all" />
          </Route>
          <Route path="/list/:scope"><List stuffs={stuffs} onDelete={deleteStuff} onSetFavorite={setFavorite} /></Route>
          <Route path="/new"><Create onCreate={addStuff} /></Route>
          <Route path="*">
              <NoMatch />
            </Route>
        </Switch>
      </section>
    </Router>
  );
}

function NoMatch() {
  const location = useLocation();
  return (
    <div>
      <h3>
        No match for <code>{location.pathname}</code>
      </h3>
    </div>
  )
}

export default App;
