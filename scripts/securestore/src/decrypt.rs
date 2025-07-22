use std::{
    fs::{self, File},
    io::{Read, Write},
    path::Path,
};

use aes_gcm::{
    aead::{Aead, KeyInit},
    Aes256Gcm, Nonce,
};
use base64::engine::general_purpose;
use base64::Engine as _;
use pbkdf2::pbkdf2_hmac;
use sha2::Sha256;

const NONCE_SIZE: usize = 12;
const SALT_SIZE: usize = 16;
const PBKDF2_ITERATIONS: u32 = 100_000;

pub fn run(input_file: &str, output_dir: &str, password: &str) -> anyhow::Result<()> {
    let mut input_data = Vec::new();
    File::open(input_file)?.read_to_end(&mut input_data)?;

    let salt = &input_data[..SALT_SIZE];
    let nonce = &input_data[SALT_SIZE..SALT_SIZE + NONCE_SIZE];
    let ciphertext = &input_data[SALT_SIZE + NONCE_SIZE..];

    let mut key = [0u8; 32];
    pbkdf2_hmac::<Sha256>(password.as_bytes(), salt, PBKDF2_ITERATIONS, &mut key);

    let cipher = Aes256Gcm::new_from_slice(&key).map_err(|e| anyhow::anyhow!(e.to_string()))?;
    let plaintext = cipher
        .decrypt(Nonce::from_slice(nonce), ciphertext)
        .map_err(|e| anyhow::anyhow!(e.to_string()))?;

    let contents = String::from_utf8(plaintext)?;
    let mut lines = contents.lines();

    while let Some(path_line) = lines.next() {
        if let Some(data_line) = lines.next() {
            let rel_path = Path::new(path_line);
            let full_path = Path::new(output_dir).join(rel_path);

            if let Some(parent) = full_path.parent() {
                fs::create_dir_all(parent)?;
            }

            let decoded = general_purpose::STANDARD.decode(data_line)?;
            let mut out = File::create(full_path)?;
            out.write_all(&decoded)?;

            lines.next(); // Skip separator
        }
    }

    Ok(())
}
