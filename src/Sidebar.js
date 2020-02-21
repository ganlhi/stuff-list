import React from 'react'
import { Link } from 'react-router-dom';

export default function Sidebar({nbFavorites}) {
    return <aside>
        <h1>Stuff list</h1>

        <nav>
          <ul>
              <li><Link to="/list/all">Complete list</Link></li>
              <li><Link to="/list/favorites">Favorites ({nbFavorites})</Link></li>
              <li><Link to="/new">Add stuff</Link></li>
          </ul>
        </nav>
    </aside>
}