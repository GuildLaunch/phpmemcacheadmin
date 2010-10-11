        <div class="size-4" style="float:left;margin-top:18px;">
        <div class="sub-header corner padding">Get <span class="green">Stats</span></div>
        <div class="container corner padding">
            <div class="line">
                <span class="left">Slabs Allocated</span>
                <?php echo $slabs['active_slabs']; ?>
            </div>
            <div class="line">
                <span class="left">Slabs Used</span>
                <?php echo $slabs['active_slabs']; ?>
            </div>
            <div class="line">
                <span class="left">Memory Used</span>
                <?php echo Library_Analysis::byteResize($slabs['total_malloced']); ?>Bytes
            </div>
            <div class="line">
                <span class="left">Wasted</span>
                <?php echo Library_Analysis::byteResize($slabs['total_wasted']); ?>Bytes
            </div>
        </div>
        <br/>
    </div>
    <div class="size-2" style="float:left; padding-left:9px;">
        <form method="post" id="flushForm" action="commands.php">
        <div class="header corner padding size-3cols" style="text-align:center;">
            <a href="?server=<?php echo $_GET['server']; ?>">See Stats</a> |
            <input type="hidden" name="request_server" value="<?php echo $_GET['server']; ?>"/>
            <input type="hidden" name="request_api" value="<?php echo $_ini->get('flush_all_api'); ?>"/>
            <input type="hidden" name="request_command" value="flush_all"/>
            <a href="#" onclick="flushServer(document.getElementById('flushForm'));">Flush this Server</a>
        </div>
        </form>
        <br/>
    </div>

    <div class="size-1" style="float:left; padding-left:9px;">
        <div class="container corner" style="padding:9px;">
                For more informations about memcached slabs stats, see memcached protocol
                <a href="http://github.com/memcached/memcached/blob/master/doc/protocol.txt#L470" target="_blank"><span class="green">here</span></a>
        </div>
    </div>

    <table class="full-size" cellspacing="0" cellpadding="0">
        <tr>
<?php
$actualSlab = 0;

# Slabs parsing
foreach($slabs as $id => $slab)
{
    # If Slab is Used
    if(is_numeric($id))
    {
        # Making a new line
        if($actualSlab >= 4)
        {
?>
        </tr>
        <tr>
<?php
            $actualSlab = 0;
        }
?>
        <td <?php if($actualSlab > 0) { echo 'style="padding-left:9px;"'; } ?> valign="top">
            <div class="sub-header corner padding size-5">Slab <?php echo $id; ?> <span class="green">Stats</span>
                <span style="float:right;"><a href="?server=<?php echo $_GET['server']; ?>&amp;show=items&amp;slab=<?php echo $id; ?>">See Slab Items</a></span>
            </div>
            <div class="container corner padding size-5">
                <div class="line">
                    <span class="left">Chunk Size</span>
                    <?php echo Library_Analysis::byteResize($slab['chunk_size']); ?>Bytes
                </div>
                <div class="line">
                    <span class="left">Used Chunk</span>
                    <?php echo Library_Analysis::hitResize($slab['used_chunks']); ?>
                    <span class="right">[ <?php echo Library_Analysis::valueResize($slab['used_chunks'] / $slab['total_chunks'] * 100); ?> %]</span>
                </div>
                <div class="line">
                    <span class="left">Total Chunk</span>
                    <?php echo Library_Analysis::hitResize($slab['total_chunks']); ?>
                </div>
                <div class="line">
                    <span class="left">Total Page</span>
                    <?php echo $slab['total_pages']; ?>
                </div>
                <div class="line">
                    <span class="left">Wasted</span>
                    <?php echo Library_Analysis::byteResize($slab['mem_wasted']); ?>Bytes
                </div>
                <div class="line">
                    <span class="left">Hits</span>
                    <?php echo $slab['request_rate']; ?> Request/sec
                </div>
<?php
if($slab['used_chunks'] > 0)
{ ?>
                <div class="line">
                    <span class="left">Evicted</span>
                    <?php echo $slab['items:evicted']; ?>
                </div>
                <!--
                <div class="line">
                    <span class="left">Evicted Last</span>
                    <?php echo Library_Analysis::uptime($slab['items:evicted_time']); ?>
                </div>
                <div class="line">
                    <span class="left">Out of Memory</span>
                    <?php echo $slab['items:outofmemory']; ?>
                </div>
                <div class="line">
                    <span class="left">Tail Repairs</span>
                    <?php echo $slab['items:tailrepairs']; ?>
                </div>
                -->
<?php }
else
{?>
                <div class="line">
                    <span class="left">Slab is allocated but empty</span>
                </div>
<?php } ?>
            </div>
            <br/>
            </td>
<?php
            $actualSlab++;
    }
?>
<?php
}
for(true; $actualSlab < 4 ; $actualSlab++)
{
    echo '<td style="width:100%;"></td>';
}
?>
        </tr>
    </table>