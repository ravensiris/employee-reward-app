import { InMemoryCache, makeVar } from "@apollo/client";

export interface NavbarState {
  hidden: boolean;
}

const navbarInitialState: NavbarState = {
  hidden: true,
};
export const navbarStateVar = makeVar<NavbarState>(navbarInitialState);

export const cache: InMemoryCache = new InMemoryCache({
  typePolicies: {
    Query: {
      fields: {
        navbar: {
          read() {
            return navbarStateVar();
          },
        },
      },
    },
  },
});
