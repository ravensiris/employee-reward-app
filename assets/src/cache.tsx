import { InMemoryCache, makeVar } from "@apollo/client";

/** Interface for storing navbar state for mobile devices */
export interface NavbarState {
  /** Whether navbar is collapsed or not */
  hidden: boolean;
}

const navbarInitialState: NavbarState = {
  hidden: true,
};
/** Stores NavBar state */
export const navbarStateVar = makeVar<NavbarState>(navbarInitialState);

/** Interface for storing messages passed by Phoenix get_flash */
export interface FlashState {
  /** Whether message was already shown to the user */
  consumed: boolean;
  /** Last emitted message */
  message?: string;
}

const flashInitialState: FlashState = {
  consumed: true,
  message: "",
};
/** Stores Phoenix's get_flash(_, :error) state */
export const errorFlashStateVar = makeVar<FlashState>(flashInitialState);
/** Stores Phoenix's get_flash(_, :info) state */
export const infoFlashStateVar = makeVar<FlashState>(flashInitialState);

export const cache: InMemoryCache = new InMemoryCache({
  typePolicies: {
    Query: {
      fields: {
        navbar: {
          read() {
            return navbarStateVar();
          },
        },
        errorFlash: {
          read() {
            return errorFlashStateVar();
          },
        },
        infoFlash: {
          read() {
            return infoFlashStateVar();
          },
        },
      },
    },
  },
});
