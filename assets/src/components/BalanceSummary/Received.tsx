export default function Received() {
  return (
    <div className="tile is-parent is-vertical">
      <div className="tile is-child notification is-danger">
        <p className="title">Sent</p>
        <p className="subtitle">5$</p>
        <div className="buttons">
          <button className="button is-danger is-light">Send</button>
        </div>
      </div>
    </div>
  );
}
