import { useState } from "react";

function App() {
  const [status, setStatus] = useState("");

  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [user, setUser] = useState(null);
  
  const [file, setFile] = useState(null);
  const [uploadMessage, setUploadMessage] = useState("");

  const checkBackend = async () => {
    try {
      const response = await fetch(
        "http://production-full-app-alb-1938323925.us-east-1.elb.amazonaws.com/health"
      );

      const data = await response.json();

      setStatus(data.status);

    } catch (error) {
      console.error(error);
      setStatus("Backend unreachable");
    }
  };

  const createUser = async () => {
    try {
      const response = await fetch(
        "http://production-full-app-alb-1938323925.us-east-1.elb.amazonaws.com/users",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json"
          },
          body: JSON.stringify({
            name,
            email
          })
        }
      );

      const data = await response.json();

      setUser(data);

    } catch (error) {
      console.error(error);
    }
  };

  const uploadFile = async () => {

    const formData = new FormData();

    formData.append("file", file);

    try {

      const response = await fetch(
        "http://production-full-app-alb-1938323925.us-east-1.elb.amazonaws.com/upload",
        {
          method: "POST",
          body: formData
        }
    );

    const data = await response.json();

    setUploadMessage(data.message);

  } catch (error) {

    console.error(error);

    setUploadMessage("Upload failed");
  }
};

  return (
    <div>

      <h1>Production Full App</h1>

      <button onClick={checkBackend}>
        Check Backend
      </button>

      <h2>Backend Status: {status}</h2>

      <hr />

      <h2>Create User</h2>

      <input
        type="text"
        placeholder="Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />

      <br /><br />

      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />

      <br /><br />

      <button onClick={createUser}>
        Create User
      </button>

      {user && (
        <div>
          <h3>User Created</h3>

          <p>ID: {user.user_id}</p>
          <p>Name: {user.name}</p>
          <p>Email: {user.email}</p>

        </div>
      )}

      <hr />

      <h2>Upload File</h2>

      <input
        type="file"
        onChange={(e) => setFile(e.target.files[0])}
      />

      <br /><br />

      <button onClick={uploadFile}>
        Upload File
      </button>

      <p>{uploadMessage}</p>
    
    </div>
  );
}

export default App;
