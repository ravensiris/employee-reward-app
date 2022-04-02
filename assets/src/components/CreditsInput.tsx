import { useMe } from "$/operations/queries/user"
import React from "react"

export interface Props {
  amount: number
  setAmount: React.Dispatch<React.SetStateAction<number>>
}

export default function CreditsInput({ amount, setAmount }: Props) {
  const { data: meData } = useMe()
  const balance = meData?.me.balance?.balance
  const onChange: React.ChangeEventHandler<HTMLInputElement> = e => {
    const value = parseInt(e.target.value)
    if (!isNaN(value) && value > 0 && balance && value <= balance) {
      setAmount(value)
    }
  }
  return (
    <input type="number" className="input" value={amount} onChange={onChange} />
  )
}
