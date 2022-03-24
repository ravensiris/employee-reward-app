interface InputProps {
  /** Input's label text */
  children?: React.ReactNode;
}

/**
 * Placeholder for an input form field that is supposed to be hydrated in.
 */
export default function Input({ children }: InputProps) {
  return (
    <div>
      <label>{children}</label>
      <div>
        <input />
      </div>
    </div>
  );
}
