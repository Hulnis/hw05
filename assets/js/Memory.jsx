import React from 'react'
import ReactDOM from 'react-dom'
import { Button } from 'reactstrap'

export default function run_memory_game(root) {
  ReactDOM.render(<MemoryGame />, root)
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
    // const {
    //   cards,
    //   counter,
    //   delayOn,
    //   oneClicked,
    //   prevCard,
    // } = this.state
    // if (!delayOn) {
    //   this.setState({
    //     counter: counter + 1,
    //   })
    //   if (oneClicked) {
    //     if (clickedCard.value === prevCard.value) {
    //       const newCards = []
    //       cards.forEach(function(card) {
    //         if (card.value == clickedCard.value) {
    //           newCards.push({
    //             state: cardStates.solved,
    //             value: card.value,
    //             weight: card.weight,
    //           })
    //         } else {
    //           newCards.push(Object.assign({}, card))
    //         }
    //       })
    //       this.setState({
    //         cards: newCards,
    //         prevCard: null,
    //         oneClicked: false,
    //       })
    //     } else {
    //       this.setState({
    //         cards: this.revealCard(clickedCard),
    //         delayOn: true,
    //         oneClicked: false,
    //         prevCard: null,
    //       })
    //       setTimeout(function() {
    //         this.setState({
    //           cards: this.hideNonSuccessCard(),
    //           delayOn: false,
    //         })
    //       }.bind(this), 1000)
    //     }
    //   } else {
    //     this.setState({
    //       cards: this.revealCard(clickedCard),
    //       oneClicked: true,
    //       prevCard: clickedCard
    //     })
    //   }
    // }
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
