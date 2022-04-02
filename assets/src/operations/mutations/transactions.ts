import { gql, useMutation } from "@apollo/client"
import type {MutationHookOptions} from "@apollo/client"

export const SEND_CREDITS = gql`
  mutation sendCredits($to: UUID4!, $amount: Int!){
    transaction(to: $to, amount: $amount){
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

export const useSendCredits = (mutationOptions?: MutationHookOptions) => useMutation(SEND_CREDITS, mutationOptions)