import React from 'react'
import ReactDOM from 'react-dom'
import { Button } from 'reactstrap'

export default function run_memory_game(root, channel) {
  ReactDOM.render(<MemoryGame channel={channel}/>, root)
}

class MemoryGame extends React.Component {
  constructor(props) {
    super(props)

    // Setup socket and stuff
    this.channel = props.channel

    this.state = {
      cards: [],
      counter: 0,
      delayOn: false,
    }

    this.channel.join()
        .receive("ok", this.receiveView.bind(this))
        .receive("error", resp => { console.log("Unable to join", resp) })
  }

  receiveView(view) {
    console.log("view", view)
    this.setState({
      cards: view.cards,
      counter: view.counter,
    })
  }

  clickCard(clickedCard) {
    const {
      delayOn,
    } = this.state
    if(delay) {
      this.channel.push("click", { card: clickedCard.key})
        .receive("ok", this.receiveView.bind(this))

      setTimeout(function() {
        this.setState({
          delayOn: false,
        })
      }.bind(this), 1000)
    }
  }

  restartGame() {
    this.channel.push("restart")
      .receive("ok", this.receiveView.bind(this))
  }

  render() {
    const {
      cards,
      counter,
    } = this.state
    console.log("cards", cards)
    const cardDraw = []
    for (var i = 0; i < 4; i++) {
      const row = []
      for (var j = 0; j < 4; j++) {
        const card = cards[(i * 4) + j]
        var color = "white"
        if (card.state === "solved") {
          color = "green"
        } else if (card.state === "revealed") {
          color = "coral"
        }
        const styles = {
          backgroundColor: color
        }
        const showText = (card.state === "solved" || card.state === "revealed")
        row.push(
          <div style={styles} className="card" onClick={() => this.clickCard(card)} key={card.key}>
            {showText && card.value}
          </div>
        )
      }
      cardDraw.push(<div className="col" key={"col" + i}>{row}</div>)
    }
    return (
      <div>
        <div className="row">
          {cardDraw}
        </div>
        <Button onClick={this.restartGame.bind(this)}>Restart Game</Button>
        <p>{counter}</p>
      </div>
    )
  }
}
