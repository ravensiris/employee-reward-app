import { gql } from "@apollo/client"

export const SEND_CREDITS = gql`
  mutation sendCredits($to: UUID4!, $amount: Int!){
    sendCredits(
        to: $to, 
        amount: $amount){
    amount,
    toUser{ 
      id
   	  name
      email
    },
    fromUser { 
      id
      name
      email
    }
  }
  }
`