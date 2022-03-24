import { GET_ME, MeQuery } from "$queries/user";
import { useQuery } from "@apollo/client";

export default function Hello() {
  const { loading, error, data } = useQuery<MeQuery>(GET_ME);
  if (loading || error || !data) return <></>;

  const name = data.me.name || data.me.email;
  return (
    <section className="section hero is-primary">
      <div className="hero-body">
        <p className="title">Hello,</p>
        <p className="subtitle">{name}</p>
      </div>
    </section>
  );
}
