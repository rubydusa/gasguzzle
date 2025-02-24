//! Example of using the HTTP provider using the `on_http` method.

use alloy::providers::{Provider, ProviderBuilder};
use anyhow::Result;

#[tokio::main]
async fn main() -> Result<()> {
    let rpc_url = "https://holesky.drpc.org".parse()?;
    let provider = ProviderBuilder::new().on_http(rpc_url);
    // provider.trace_transaction();

    Ok(())
}
