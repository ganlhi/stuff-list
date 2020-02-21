import React, { useState } from 'react'
import { useHistory } from 'react-router-dom';

export default function Create({onCreate}) {
    const history = useHistory();

    const [name, setName] = useState('');
    
    const createStuff = () => {
        if (!name) return;
        onCreate(name);
        history.push('/list/all');
    }

    return <>
        <input value={name} onChange={({target: {value}}) => setName(value)} placeholder="Stuff name" />
        <button onClick={createStuff}>Add</button>
    </>
}