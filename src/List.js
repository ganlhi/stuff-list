import React from 'react'
import { useParams, Link } from 'react-router-dom'

export default function List({stuffs, onDelete, onSetFavorite}) {
    const {scope} = useParams();

    const filteredStuffs = scope === 'favorites'
        ? stuffs.filter(s => s.favorite)
        : stuffs;

    return (
        filteredStuffs.length === 0
            ? <p>No stuff here! You should <Link to="/new">add one</Link>...</p>
            : <ul>
                {
                    filteredStuffs.map(s => <ListItem key={s.id} stuff={s} onDelete={onDelete} onSetFavorite={onSetFavorite} />)
                }
            </ul>
    )
}

function ListItem({stuff, onDelete, onSetFavorite}) {
    return <li>
        <span>{stuff.name}</span>
        <input type="checkbox" checked={stuff.favorite} title="Favorite" onChange={({target: {checked}}) => onSetFavorite(stuff.id, checked)} />
        <button onClick={() => onDelete(stuff.id)}>X</button>
    </li>
}