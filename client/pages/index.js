//import axios from 'axios';
import fetch from 'isomorphic-unfetch';
import React from 'react';
import Container from '@material-ui/core/Container';

import { makeStyles } from '@material-ui/core/styles';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import IconButton from '@material-ui/core/IconButton';
import Paper from '@material-ui/core/Paper';

const useStyles = makeStyles({
  table: {
    minWidth: 650,
  },
});

function Index({ cards }) {
    const classes = useStyles();

    return (
        <div>
            <AppBar position="static">
                <Toolbar variant="dense">
                    <IconButton edge="start" className={classes.menuButton} color="inherit" aria-label="menu">
                    </IconButton>
                    <Typography variant="h6" color="inherit">
                    Timecard
                    </Typography>
                </Toolbar>
            </AppBar>
            <Container fixed>
            <TableContainer component={Paper}>
            <Table className={classes.table} aria-label="simple table">
                <TableHead>
                <TableRow>
                    <TableCell>Date</TableCell>
                    <TableCell align="right">Start</TableCell>
                    <TableCell align="right">End</TableCell>
                    <TableCell align="right">Rest</TableCell>
                    <TableCell align="right">Note</TableCell>
                </TableRow>
                </TableHead>
                <TableBody>
                {cards.data.timecard.map((card) => (
                    <TableRow key={card.id}>
                    <TableCell component="th" scope="row">
                        {card.date}
                    </TableCell>
                    <TableCell align="right">{card.start}</TableCell>
                    <TableCell align="right">{card.end}</TableCell>
                    <TableCell align="right">{card.rest}</TableCell>
                    <TableCell align="right">{card.note}</TableCell>
                    </TableRow>
                ))}
                </TableBody>
            </Table>
            </TableContainer>
            </Container>
        </div>
    )
}

export const getStaticProps = async () => {
    const res = await fetch('http://api:5000/api/cards');
    const cards = await res.json()

    console.log(cards)
    return {
        props: {
            cards,
        },
    }
}


export default Index;