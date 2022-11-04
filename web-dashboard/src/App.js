import { useState, useEffect } from 'react';
import axios from 'axios';

import '@tremor/react/dist/esm/tremor.css';
import {
  Card,
  Table,
  TableHead,
  TableRow,
  TableHeaderCell,
  TableBody,
  TableCell,
  Text,
  Title,
} from "@tremor/react";

import './App.css';

// const data = [
//   {
//      "models" : [
//         {
//            "inventory" : 23,
//            "name" : "SODANO"
//         },
//         {
//            "inventory" : 90,
//            "name" : "SEVIDE"
//         },
//         {
//            "inventory" : 97,
//            "name" : "MIRIRA"
//         },
//         {
//            "inventory" : 33,
//            "name" : "GREG"
//         },
//         {
//            "inventory" : 30,
//            "name" : "WUMA"
//         },
//         {
//            "inventory" : 45,
//            "name" : "CADEVEN"
//         },
//         {
//            "inventory" : 92,
//            "name" : "BEODA"
//         },
//         {
//            "inventory" : 7,
//            "name" : "ALALIWEN"
//         },
//         {
//            "inventory" : 71,
//            "name" : "RASIEN"
//         },
//         {
//            "inventory" : 58,
//            "name" : "CADAUDIA"
//         },
//         {
//            "inventory" : 14,
//            "name" : "MCTYRE"
//         }
//      ],
//      "name" : "ALDO_Auburn_Mall"
//   },
//   {
//      "models" : [        {
//       "inventory" : 58,
//       "name" : "CADAUDIA"
//    },
//    {
//       "inventory" : 14,
//       "name" : "MCTYRE"
//    }],
//      "name" : "ALDO_HOLx"
//   }];

function App() {

  const [data, setData] = useState([]);

  useEffect(() => {
    setInterval(() => {
      axios.get('http://localhost:4567/inventory')
      .then(function (response) {
        // handle success
        console.log(response);
        setData(response.data);
      })
    }, 1000);
  }, []);

  return (
      data.map((store, index) => (
        <Card maxWidth="max-w-sm" key={index}>
          <Title>{store.name}</Title>
          <Table marginTop="mt-6">
            <TableHead>
              <TableRow>
                <TableHeaderCell>Shoe Model</TableHeaderCell>
                <TableHeaderCell>Inventory</TableHeaderCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {store.models.map((model, index) => (
                <TableRow key={index}>
                  <TableCell>{model.name}</TableCell>
                  <TableCell>
                    <Text>{model.inventory}</Text>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </Card>
      ))
  );
}

export default App;
