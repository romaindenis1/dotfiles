use std::{
    fs::File,
    io::{Read, Write},
};

use aes_gcm::{
    aead::{Aead, KeyInit, OsRng},
    Aes256Gcm, Nonce,
};
use base64::{engine::general_purpose, Engine as _};
use pbkdf2::pbkdf2_hmac;
use rand::RngCore;
use sha2::Sha256;
use walkdir::WalkDir;

const NONCE_SIZE: usize = 12;
const SALT_SIZE: usize = 16;
const PBKDF2_ITERATIONS: u32 = 100_000;

pub fn run(source_dir: &str, output_file: &str, password: &str) -> anyhow::Result<()> {
    let mut buffer: Vec<u8> = Vec::new();

    for entry in WalkDir::new(source_dir).into_iter().filter_map(Result::ok) {
        let path = entry.path();
        if path.is_file() {
            let rel_path = path.strip_prefix(source_dir)?;
            let mut file_data = Vec::new();
            File::open(path)?.read_to_end(&mut file_data)?;
            let encoded = general_purpose::STANDARD.encode(&file_data);

            buffer.extend_from_slice(rel_path.to_str().unwrap().as_bytes());
            buffer.push(b'\n');
            buffer.extend_from_slice(encoded.as_bytes());
            buffer.push(b'\n');
            buffer.push(b'\n'); // Separator
        }
    }

    // Encryption
    let mut salt = [0u8; SALT_SIZE];
    OsRng.fill_bytes(&mut salt);

    let mut key = [0u8; 32];
    pbkdf2_hmac::<Sha256>(password.as_bytes(), &salt, PBKDF2_ITERATIONS, &mut key);

    let cipher = Aes256Gcm::new_from_slice(&key).map_err(|e| anyhow::anyhow!(e.to_string()))?;
    let mut nonce = [0u8; NONCE_SIZE];
    OsRng.fill_bytes(&mut nonce);

    let ciphertext = cipher
        .encrypt(Nonce::from_slice(&nonce), buffer.as_ref())
        .map_err(|e| anyhow::anyhow!(e.to_string()))?;

    let mut output = File::create(output_file)?;
    output.write_all(&salt)?;
    output.write_all(&nonce)?;
    output.write_all(&ciphertext)?;
    Ok(())
}
