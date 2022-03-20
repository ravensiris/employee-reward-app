import { useState, useCallback } from "react";
import logo from "./logo.svg";

function App() {
  const [count, setCount] = useState(0);
  const increment = useCallback(() => {
    setCount((count) => count + 1);
  }, [setCount]);

  return (
    <section className="section">
      <div className="container">
        <img src={logo} alt="React logo" width={120} />
        <h1 className="title">Hello World</h1>
        <p className="subtitle">
          A React app running on top of <strong>Phoenix</strong> and with
          support for <strong>Bulma</strong> and <strong>SASS</strong>!
        </p>
        <button className="button is-primary" onClick={increment}>
          Click me: {count}
        </button>
      </div>
    </section>
  );
}

export default App;
