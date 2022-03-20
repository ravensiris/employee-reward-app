import { gql } from "@apollo/client";

export const GET_NAVBAR = gql`
query getNavbar{
    navbar @client{
        hidden
    }
}
`
