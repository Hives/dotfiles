#! /usr/bin/env kotlin

@file:DependsOn("com.google.cloud:google-cloud-datastore:1.107.1")

import com.google.api.gax.retrying.RetrySettings
import com.google.cloud.datastore.Datastore
import com.google.cloud.datastore.DatastoreOptions
import com.google.cloud.datastore.Query
import com.google.cloud.http.HttpTransportOptions
import org.threeten.bp.Duration
import java.text.NumberFormat

fun createDatastoreClient(
    project: String,
    namespace: String,
    timeoutMillis: Int = 5000
): Datastore {
    val builder = DatastoreOptions
        .newBuilder()
        .setTransportOptions(
            HttpTransportOptions.newBuilder()
                .setConnectTimeout(timeoutMillis)
                .setReadTimeout(timeoutMillis)
                .build()
        )
        .setRetrySettings(
            RetrySettings.newBuilder()
                .setTotalTimeout(Duration.ofMillis(timeoutMillis.toLong()))
                .build()
        )
        .setProjectId(project)
        .setNamespace(namespace)

    return builder.build().service
}

fun keysOnlyQuery(kind: String) = Query.newKeyQueryBuilder().setKind(kind).build()

fun Number.formatWithCommas() = NumberFormat.getNumberInstance().format(this)

val docs =
    """
        |Counts the number of entities of a given kind in a given namespace.
        |
        |Usage:
        |  count-entities.main.kts GCP_PROJECT DATASTORE_NAMESPACE KIND
        |""".trimMargin()

fun main() {
    if (args.size < 3) println(docs)
    else {
        val (project, namespace, kind) = args

        val datastore = createDatastoreClient(project, namespace)

        println()

        datastore.run(keysOnlyQuery(kind)).asSequence().count()
            .also { count ->
                println("Number of entities of kind $kind in namespace $namespace: ${count.formatWithCommas()}")
            }
    }
}

main()
